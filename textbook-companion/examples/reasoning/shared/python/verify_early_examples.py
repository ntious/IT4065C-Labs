import os
"""Bounded fixture execution and author-example checks; no repository writes."""
from pathlib import Path
from decimal import Decimal, InvalidOperation, ROUND_FLOOR
from datetime import date, datetime, timezone
from collections import defaultdict
import ast, csv, hashlib, json, re, sqlite3, subprocess
import sys, platform
if sys.flags.optimize: raise RuntimeError('Assertions are required; do not run Python with -O.')
PACKAGE=Path(__file__).resolve().parents[2]
ROOT=Path(os.environ['EDS_RESULT_DIR'])/'chapters-07-09';ROOT.mkdir(parents=True,exist_ok=True)
if (ROOT/'example_validation.json').exists(): (ROOT/'example_validation.json').unlink()
REPO=PACKAGE/'shared/test-data/repository-baseline'
BASE='d860dd98256a8090ffc6bd3766c59cb15a553c12'
paths=['scripts/optional_labs.py','scripts/course.py','data/ingestion/sales.csv','data/ingestion/events.jsonl','data/ingestion/purpose.txt']
before={p:hashlib.sha256((REPO/p).read_bytes()).hexdigest() for p in paths}
expected_hashes=json.loads((PACKAGE/'shared/test-data/baseline_sha256.json').read_text())
for p in paths:
    if before[p]!=expected_hashes[p]: raise RuntimeError('Baseline fixture hash mismatch: '+p)
# Execute only the two exact functions, not module setup or writing entry points.
namespace={'ROOT':REPO,'csv':csv,'date':date,'Decimal':Decimal,'InvalidOperation':InvalidOperation,'hashlib':hashlib,'json':json,'re':re}
for path,name in [('scripts/course.py','require'),('scripts/optional_labs.py','curate')]:
    tree=ast.parse((REPO/path).read_text(encoding='utf-8'))
    fn=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name==name)
    exec(compile(ast.Module(body=[fn],type_ignores=[]),str(REPO/path),'exec'),namespace)
result=namespace['curate'](REPO/'data/ingestion');records=result['accepted']
assert len(result['catalog'])==3 and len(records)==3 and len(result['quarantine'])==2
assert sum(Decimal(r['amount']) for r in records)==Decimal('45.00')
assert {r['record_id'] for r in records}=={'csv-1','csv-2','json-1'}
assert all(set(r)=={'record_id','event_date','amount','source'} for r in records)
assert all(set(r)=={'source','record_number','reason'} for r in result['quarantine'])
assert next(r for r in records if r['record_id']=='json-1')['source']=='events.jsonl'
assert all(c['ai_use']=='Individual profiling not approved' for c in result['catalog'])
for c in result['catalog']:assert c['sha256']==hashlib.sha256((REPO/'data/ingestion'/c['source']).read_bytes()).hexdigest()
def publish_in_memory(rows,previous):
    if len({r['record_id'] for r in rows})!=len(rows):return previous,False
    out=defaultdict(lambda:[0,Decimal('0')])
    for r in rows:out[r['event_date']][0]+=1;out[r['event_date']][1]+=Decimal(r['amount'])
    return dict(out),True
first,ok=publish_in_memory(records,{})
assert ok and first=={'2026-01-10':[2,Decimal('20.00')],'2026-01-11':[1,Decimal('25.00')]}
blocked,ok=publish_in_memory(records+[records[0]],first);assert not ok and blocked==first
retry,ok=publish_in_memory(records,first);assert ok and retry==first
corrected=[dict(r,amount='14.50') if r['record_id']=='csv-1' else r for r in records]
changed,ok=publish_in_memory(corrected,first)
assert ok and changed['2026-01-10'][1]==Decimal('22.00') and sum(v[1] for v in changed.values())==Decimal('47.00')
body=(PACKAGE/'shared/listings/chapter-07.md').read_text(encoding='utf-8');sqlblocks=re.findall(r'```sql\n(.*?)```',body,re.S)
con=sqlite3.connect(':memory:');con.execute('CREATE TABLE approved_sales_events (event_date TEXT, amount NUMERIC)')
con.executemany('INSERT INTO approved_sales_events VALUES (?,?)',[(r['event_date'],r['amount']) for r in records])
aggregate=next(s for s in sqlblocks if "ref('approved_sales_events')" in s).replace("{{ ref('approved_sales_events') }}",'approved_sales_events')
assert sorted(con.execute(aggregate).fetchall())==[('2026-01-10',2,20),('2026-01-11',1,25)]
con.executescript('''CREATE TABLE incoming_sales(sale_id TEXT, source_system TEXT, source_product_id TEXT, sold_on TEXT);
CREATE TABLE product_map(source_system TEXT, source_product_id TEXT, product_id TEXT);
CREATE TABLE product_versions(product_key INTEGER, product_id TEXT, valid_from TEXT, valid_to TEXT);
INSERT INTO product_map VALUES ('online','3','P300'),('store','WB-300','P300');
INSERT INTO product_versions VALUES (1,'P300','2026-01-01','2026-01-31'),(2,'P300','2026-02-01','9999-12-31');
INSERT INTO incoming_sales VALUES ('late-jan','online','3','2026-01-20'),('jan-end','store','WB-300','2026-01-31'),('feb-start','online','3','2026-02-01'),('march','store','WB-300','2026-03-01'),('unmapped','online','9','2026-03-01'),('before-history','store','WB-300','2025-12-31');''')
candidate=next(s for s in sqlblocks if 'WITH candidates' in s)
assert dict(con.execute(candidate))=={'before-history':0,'unmapped':0}
selection=candidate.split('SELECT sale_id, COUNT(product_key)')[0]+'SELECT sale_id, product_key FROM candidates WHERE product_key IS NOT NULL'
assert dict(con.execute(selection))=={'late-jan':1,'jan-end':1,'feb-start':2,'march':2}
con.execute("INSERT INTO product_versions VALUES (3,'P300','2026-01-15','2026-02-15')")
assert dict(con.execute(candidate))=={'before-history':0,'feb-start':2,'jan-end':2,'late-jan':2,'unmapped':0}
con.close()
def allocate(amounts,charge):
    exact=[charge*a/sum(amounts) for a in amounts];base=[x.quantize(Decimal('.01'),rounding=ROUND_FLOOR) for x in exact]
    cents=int((charge-sum(base))*100);order=sorted(range(len(base)),key=lambda i:(-(exact[i]-base[i]),i))
    for i in order[:cents]:base[i]+=Decimal('.01')
    return base
assert allocate([Decimal(20),Decimal(10)],Decimal(1))==[Decimal('.67'),Decimal('.33')]
assert allocate([Decimal(1)]*3,Decimal(1))==[Decimal('.34'),Decimal('.33'),Decimal('.33')]
assert sum(allocate([Decimal(1)]*3,Decimal(1)))==Decimal(1)
assert 100-sum([10,12,18,9,11,15])==25
assert len({'A','B'})==2 and len({'B'})==1 and len({'B','C'})==2 and {'A','B'}!={'B','C'}
assert len({'A','C'} & {'A','B','C','D'})/len({'A','B','C','D'})==.5
after={p:hashlib.sha256((REPO/p).read_bytes()).hexdigest() for p in paths};assert before==after
out={'status':'PASS','executed_at_utc':datetime.now(timezone.utc).isoformat(),'baseline':BASE,'source_hashes_unchanged':before,'repository_execution':{'evidence':'R-DOC + AUTH-OBS','scope':'Exact curate and require functions extracted through AST; unchanged baseline fixture; no course entry point or publisher executed','catalog_entries':3,'accepted':3,'quarantined':2,'accepted_total':'45.00','allowlist_and_fingerprints':'PASS'},'author_examples':{'evidence':'AUTH + AUTH-OBS','aggregation_sqlite':'PASS','temporal_lookup_sqlite':'PASS: late event, inclusive date boundaries, unmapped identity, missing history, overlap','allocation':'0.67 + 0.33 = 1.00; residual tie case 0.34 + 0.33 + 0.33','duplicate_blocked_in_memory':True,'prior_result_preserved_in_memory':True,'retry_idempotent_in_memory':True,'corrected_day_total':'22.00','corrected_overall_total':'47.00','repeated_release_inference':'100 - 75 = 25','active_customer_counts':[2,1,2],'cohort_retention':'2/4 = 50%'},'limits':'This companion checks SQLite and the in-memory teaching model, not PostgreSQL publication/rollback, dbt compilation, a scheduler, or production behavior. Separate PostgreSQL book-example checks are recorded in validation/observed_results.json.'}
out['environment']={'python':sys.version,'os':platform.platform(),'sqlite':sqlite3.sqlite_version}
(ROOT/'example_validation.json').write_text(json.dumps(out,indent=2),encoding='utf-8');print(json.dumps(out,indent=2))
