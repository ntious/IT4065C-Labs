import os
"""Verify manuscript examples in a private PostgreSQL cluster and pinned files.

No course database, publisher, model training, or repository working file is
modified. Uses PostgreSQL CLI programs; override PG_BINDIR when necessary.
"""
from pathlib import Path
from decimal import Decimal as D, ROUND_FLOOR
from datetime import datetime, timezone, date
import ast, csv, hashlib, io, json, os, re, shutil, subprocess, tempfile

import sys, platform
if sys.flags.optimize: raise RuntimeError('Assertions are required; do not run Python with -O.')
PACKAGE=Path(__file__).resolve().parents[2]
ROOT=Path(os.environ['EDS_RESULT_DIR'])
REPO=PACKAGE/'shared/test-data/repository-baseline'
BASE='d860dd98256a8090ffc6bd3766c59cb15a553c12'
EARLY=ROOT/'chapters-07-09'; LATE=ROOT/'chapters-15-18'
for d in [EARLY,LATE]:
    (d/'validation').mkdir(parents=True,exist_ok=True)
    old=d/'validation/observed_results.json'
    if old.exists(): old.unlink()
expected_hashes=json.loads((PACKAGE/'shared/test-data/baseline_sha256.json').read_text())
for path,digest in expected_hashes.items():
    if hashlib.sha256((REPO/path).read_bytes()).hexdigest()!=digest: raise RuntimeError('Baseline fixture hash mismatch: '+path)
def baseline(path): return (REPO/path).read_bytes()
hashes={}
def source(path):
    b=baseline(path);hashes[path]=hashlib.sha256(b).hexdigest();return b
def query(ch,token):
    txt=(PACKAGE/f'shared/listings/chapter-{ch:02}.md').read_text()
    return next(s for s in re.findall(r'```sql\n(.*?)```',txt,re.S) if token in s)
(LATE/'validation/ai_predictions_baseline.csv').write_bytes((REPO/'data/ai_predictions.csv').read_bytes())
results={'executed_at_utc':datetime.now(timezone.utc).isoformat(),'evidence':'AUTH + AUTH-OBS; pinned curator R-DOC + AUTH-OBS','baseline':BASE,'checks':{}}
with tempfile.TemporaryDirectory(prefix='eds-reasoning-') as td:
    work=Path(td);fixture=work/'data/ingestion';fixture.mkdir(parents=True)
    for name in ['sales.csv','events.jsonl','purpose.txt']:(fixture/name).write_bytes(source('data/ingestion/'+name))
    ns={'ROOT':work,'csv':csv,'date':date,'Decimal':D,'InvalidOperation':__import__('decimal').InvalidOperation,'hashlib':hashlib,'json':json,'re':re}
    for path,name in [('scripts/course.py','require'),('scripts/optional_labs.py','curate')]:
        tree=ast.parse(source(path).decode());fn=next(x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name==name)
        exec(compile(ast.Module(body=[fn],type_ignores=[]),path,'exec'),ns)
    c=ns['curate'](fixture);rows=c['accepted']
    assert (len(c['catalog']),len(rows),len(c['quarantine']))==(3,3,2)
    assert all(set(r)=={'record_id','event_date','amount','source'} for r in rows)
    assert all(set(r)=={'source','record_number','reason'} for r in c['quarantine'])
    assert sum(D(r['amount']) for r in rows)==D('45.00')
    for x in c['catalog']: assert x['sha256']==hashlib.sha256((fixture/x['source']).read_bytes()).hexdigest()
    results['checks']['curator']={'catalog':3,'accepted':3,'quarantined':2,'total':'45.00','projection':'PASS','fingerprints':'PASS','scope':'Exact pinned curate/require functions; publisher not run'}

    pg=Path(os.environ.get('PG_BINDIR','/usr/lib/postgresql/16/bin'))
    env={k:v for k,v in os.environ.items() if not k.startswith(('PG','EDS_'))};env['LC_ALL']='C.UTF-8'
    cluster=work/'pgdata';socket=work/'socket';socket.mkdir()
    subprocess.run([str(pg/'initdb'),'-D',str(cluster),'-U','demo_admin','-A','trust','--no-locale','-E','UTF8'],env=env,check=True,capture_output=True,text=True)
    # Unix socket only in a private temporary directory; no network listener.
    try:
        subprocess.run([str(pg/'pg_ctl'),'-D',str(cluster),'-l',str(work/'postgres.log'),'-o',f"-k {socket} -p 55479 -c listen_addresses=''",'-w','start'],env=env,check=True,capture_output=True,text=True)
    except BaseException:
        if (cluster/'postmaster.pid').exists():
            subprocess.run([str(pg/'pg_ctl'),'-D',str(cluster),'-m','fast','-w','stop'],env=env,check=True,capture_output=True,text=True)
        raise
    transcripts=[]
    def run(label,sql):
        cmd=[str(pg/'psql'),'-X','-h',str(socket),'-p','55479','-U','demo_admin','-d','postgres','-v','ON_ERROR_STOP=1','-At']
        r=subprocess.run(cmd,input=sql,text=True,capture_output=True,env=env)
        transcripts.append('## '+label+'\n\n```sql\n'+sql+'\n```\n\n```text\n'+r.stdout+r.stderr+'```\n')
        assert r.returncode==0,(label,r.stderr)
        return r.stdout.strip().splitlines()
    try:
        results['postgresql_version']=run('Version','SELECT version();')[0]
        s15='''SET TIME ZONE 'UTC';
CREATE TEMP TABLE approvals(principal text NOT NULL, valid_from timestamptz NOT NULL, valid_to timestamptz NOT NULL, CHECK(valid_from < valid_to));
CREATE TEMP TABLE access_events(event_id text PRIMARY KEY, principal text, occurred_at timestamptz NOT NULL, outcome text NOT NULL CHECK(outcome IN ('success','denied')));
INSERT INTO approvals VALUES ('actor_a','2026-01-11 10:00+00','2026-01-11 11:00+00'),('actor_b','2026-01-11 09:00+00','2026-01-11 10:00+00');
INSERT INTO access_events VALUES
('E1','actor_a','2026-01-11 10:10+00','success'),
('E2','actor_b','2026-01-11 10:20+00','success'),
('E3','actor_c','2026-01-11 10:25+00','success'),
('E4','actor_a','2026-01-11 10:30+00','denied'),
('E5',NULL,'2026-01-11 10:40+00','success'),
('E6','actor_a','2026-01-11 11:00+00','success');
'''
        q15=query(15,'e.event_id')
        expected15=['E1|matched','E2|no matching recorded approval','E3|no matching recorded approval','E5|identity unresolved','E6|no matching recorded approval']
        output=run('Chapter 15 six-event match',s15+q15)
        assert output[-5:]==expected15,output
        (LATE/'validation/chapter15_approval_match.sql').write_text('-- Synthetic, one resource/action. Run in a scratch PostgreSQL session.\n'+s15+q15)
        altered=q15.replace('e.occurred_at < a.valid_to','e.occurred_at <= a.valid_to')
        assert 'E6|matched' in run('Chapter 15 deliberate expiry defect',s15+altered)
        edges="INSERT INTO access_events VALUES ('E0','actor_a','2026-01-11 10:00+00','success'),('E7','actor_a','2026-01-11 10:59:59.999999+00','success'),('E8','actor_a','2026-01-11 05:10-05','success');\n"
        edgeout=run('Chapter 15 inclusive start and equivalent offset',s15+edges+q15)
        assert all(x in edgeout for x in ['E0|matched','E7|matched','E8|matched'])
        results['checks']['chapter15']={'result_rows':expected15,'boundary_checks':'inclusive start, exclusive expiry, immediately before expiry, equivalent timezone offset','mutation_check':'Changing < to <= incorrectly matches E6; detected'}

        s17='''SET TIME ZONE 'UTC';
CREATE TEMP TABLE predictions(prediction_id text PRIMARY KEY, purchase_id text NOT NULL, predicted_at timestamptz NOT NULL);
CREATE TEMP TABLE feature_history(feature_version integer PRIMARY KEY, purchase_id text NOT NULL, event_time timestamptz NOT NULL, available_at timestamptz NOT NULL, return_state text NOT NULL);
INSERT INTO feature_history VALUES (1,'P1','2026-01-10 09:00+00','2026-01-10 09:01+00','not_returned'),(2,'P1','2026-01-10 09:00+00','2026-01-20 12:00+00','returned');
INSERT INTO predictions VALUES ('P11','P1','2026-01-11 12:00+00'),('P21','P1','2026-01-21 12:00+00');
'''
        q17=query(17,'LEFT JOIN LATERAL')
        expected17=['P11|1|not_returned','P21|2|returned']
        assert run('Chapter 17 as-of features',s17+q17)[-2:]==expected17
        faulty=q17.replace('    AND h.available_at <= p.predicted_at\n','')
        assert 'P11|2|returned' in run('Chapter 17 deliberate temporal leakage',s17+faulty)
        edge17="INSERT INTO predictions VALUES ('P00','missing','2026-01-11 12:00+00'),('P20','P1','2026-01-20 12:00+00');\n"
        assert all(x in run('Chapter 17 missing history and exact availability',s17+edge17+q17) for x in ['P00||','P20|2|returned'])
        (LATE/'validation/chapter17_asof_features.sql').write_text('-- Synthetic optional manuscript example.\n'+s17+q17)
        results['checks']['chapter17_temporal']={'result_rows':expected17,'missing_history':'preserved','availability_equality':'included under stated convention','mutation_check':'Omitting availability filter leaks return into P11; detected'}

        s7='''CREATE TEMP TABLE incoming_sales(sale_id text PRIMARY KEY, source_system text, source_product_id text, sold_on date);
CREATE TEMP TABLE product_map(source_system text, source_product_id text, product_id text);
CREATE TEMP TABLE product_versions(product_key integer PRIMARY KEY, product_id text, valid_from date, valid_to date);
INSERT INTO product_map VALUES ('online','3','P300'),('store','WB-300','P300');
INSERT INTO product_versions VALUES (1,'P300','2026-01-01','2026-01-31'),(2,'P300','2026-02-01','9999-12-31');
INSERT INTO incoming_sales VALUES ('late-jan','online','3','2026-01-20'),('jan-end','store','WB-300','2026-01-31'),('feb-start','online','3','2026-02-01'),('march','store','WB-300','2026-03-01'),('unmapped','online','9','2026-03-01'),('before-history','store','WB-300','2025-12-31');
'''
        q7=query(7,'WITH candidates')
        output=run('Chapter 7 historical lookup',s7+q7)
        assert set(x for x in output if '|' in x)=={'before-history|0','unmapped|0'}
        selection=q7.split('SELECT sale_id, COUNT(product_key)')[0]+'SELECT sale_id, product_key FROM candidates WHERE product_key IS NOT NULL ORDER BY sale_id;'
        assert set(x for x in run('Chapter 7 correct historical keys',s7+selection) if '|' in x)=={'late-jan|1','jan-end|1','feb-start|2','march|2'}
        overlap="INSERT INTO product_versions VALUES(3,'P300','2026-01-15','2026-02-15');\n"
        assert set(x for x in run('Chapter 7 overlapping history',s7+overlap+q7) if '|' in x)=={'before-history|0','unmapped|0','late-jan|2','jan-end|2','feb-start|2'}
        # Inner join mutation makes both missing-history cases disappear.
        assert not any('|' in x for x in run('Chapter 7 deliberate loss of unmatched rows',s7+q7.replace('LEFT JOIN','JOIN')))
        (EARLY/'validation/chapter07_historical_lookup.sql').write_text(s7+q7+'\n'+selection)
        aggregate=query(7,"ref('approved_sales_events')").replace("{{ ref('approved_sales_events') }}",'approved_sales_events')
        sagg="CREATE TEMP TABLE approved_sales_events(event_date date,amount numeric(12,2)); INSERT INTO approved_sales_events VALUES ('2026-01-10',12.50),('2026-01-10',7.50),('2026-01-11',25.00);\n"
        assert set(x for x in run('Chapter 7 aggregation SQL, dbt reference substituted',sagg+aggregate) if '|' in x)=={'2026-01-10|2|20.00','2026-01-11|1|25.00'}
        (EARLY/'validation/chapter07_aggregation.sql').write_text(sagg+aggregate)
        results['checks']['chapter07_postgresql']={'historical_keys':'PASS','inclusive_date_boundaries':'PASS','unmapped_and_missing_history':'PASS','overlap':'PASS','aggregation':'PASS','mutation_check':'Inner joins lose missing cases; detected','limit':'dbt ref substituted by table name; dbt compilation not tested'}
    finally:
        subprocess.run([str(pg/'pg_ctl'),'-D',str(cluster),'-m','fast','-w','stop'],env=env,check=True,capture_output=True,text=True)
    for d in [EARLY,LATE]:
        (d/'validation/postgresql_transcript.md').write_text('# Isolated PostgreSQL manuscript checks\n\n'+results['postgresql_version']+'\n\nPrivate temporary cluster; no course database used. Deliberately faulty variants demonstrate the checks distinguish important defects.\n\n'+'\n'.join(transcripts))

ai=source('data/ai_predictions.csv');actual=(LATE/'validation/ai_predictions_baseline.csv').read_bytes()
assert ai==actual,'AI fixture differs from pinned commit'
records=list(csv.DictReader(io.StringIO(ai.decode())))
metrics={}
for policy in ['baseline','mitigated']:
    for group in ['A','B']:
        rs=[r for r in records if r['group']==group]
        positives=[r for r in rs if int(r['eligible'])==1]; negatives=[r for r in rs if int(r['eligible'])==0]
        selected=sum(int(r[policy]) for r in rs);fn=sum(1-int(r[policy]) for r in positives);fp=sum(int(r[policy]) for r in negatives)
        metrics[policy+'/'+group]={'selection':[selected,len(rs)],'false_negative':[fn,len(positives)],'false_positive':[fp,len(negatives)]}
assert metrics=={'baseline/A':{'selection':[4,8],'false_negative':[1,4],'false_positive':[1,4]},'baseline/B':{'selection':[1,8],'false_negative':[3,4],'false_positive':[0,4]},'mitigated/A':{'selection':[4,8],'false_negative':[1,4],'false_positive':[1,4]},'mitigated/B':{'selection':[5,8],'false_negative':[1,4],'false_positive':[2,4]}}
results['checks']['ai_fixture_metrics']=metrics
weights=list(map(D,['.30','.25','.20','.15','.10']))
ratings={'A':[4,5,4,4,3],'B':[5,4,4,4,3],'C':[4,2,3,2,5]}
scores={k:sum(w*r for w,r in zip(weights,v)) for k,v in ratings.items()}
assert scores=={'A':D('4.15'),'B':D('4.20'),'C':D('3.10')}
assert scores['B']-D('.30')==D('3.90')
costs={str(h):{'A':900+20*h,'B':1400+8*h,'C':1200+30*h} for h in [40,60]}
assert costs=={'40':{'A':1700,'B':1720,'C':2400},'60':{'A':2100,'B':1880,'C':3000}}
results['checks']['platform']={'costs':costs,'scores':{k:str(v) for k,v in scores.items()},'B_workload_downgrade':'3.90','higher_staff_rate_scores':{'A':'4.00','B':'4.05','C':'ineligible; fails budget and pending gates'},'AB_cost_break_even':str(D(500)/D(12))}
def allocate(amounts,charge):
    amounts=list(map(D,amounts));charge=D(charge);exact=[charge*a/sum(amounts) for a in amounts];rounded=[a.quantize(D('.01'),rounding=ROUND_FLOOR) for a in exact]
    cents=int((charge-sum(rounded))*100)
    order=sorted(range(len(amounts)),key=lambda i:(-(exact[i]-rounded[i]),i))
    for i in order[:cents]:rounded[i]+=D('.01')
    return rounded
assert allocate(['20','10'],'1')==[D('.67'),D('.33')]
assert allocate(['1','1','1'],'1')==[D('.34'),D('.33'),D('.33')]
assert 100-sum([10,12,18,9,11,15])==25
assert len({'A','C'} & {'A','B','C','D'})/4==.5
items=[('L1','T1',True),('L1','T2',True),('L2','T3',True),('L3','T4',False)]
assert (len(items),len({x[0] for x in items}),sum(x[2] for x in items),len({x[0] for x in items if x[2]}))==(4,3,3,2)
results['checks']['other_arithmetic']={'allocation':'0.67/0.33; residual 0.34/0.33/0.33','aggregate_disclosure':'100-75=25','cohort_retention':'2/4=0.50','lending_grain':[4,3,3,2]}
results['source_sha256']=hashes
results['environment']={'python':sys.version,'os':platform.platform(),'sqlite':__import__('sqlite3').sqlite_version}
results['status']='PASS'
results['limits']='No publisher/rollback runner, dbt build, production service, cloud platform, model training, drift detector, retrieval service, or end-to-end retail implementation executed. Earlier chapter observations are attributed, not independently rerun here.'
for d in [EARLY,LATE]: (d/'validation/observed_results.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps({'status':'PASS','postgresql':results['postgresql_version'],'checks':list(results['checks'])},indent=2))
