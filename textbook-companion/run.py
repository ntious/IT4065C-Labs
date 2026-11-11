#!/usr/bin/env python3
"""Run optional textbook demonstrations in newly created private PostgreSQL clusters.

Original teaching material: Isaac K. Nti. Adapted for isolated companion execution.
Code license: MIT; see the repository LICENSE. No course database is used.
"""
from pathlib import Path
from contextlib import contextmanager
import argparse,datetime as dt,hashlib,json,os,re,secrets,shutil,subprocess,sys,tempfile,time

ROOT=Path(__file__).resolve().parent
SUITES={'foundations':'Chapters 1–3: query scope, integrity and normalization',
        'transactions':'Chapters 4–6: quality, transactions, concurrency and analytical grain',
        'lifecycle':'Chapters 10–14: copies, access, monitoring and recovery',
        'reasoning':'Chapters 7–9 and 15–18: temporal queries, fixtures and bounded arithmetic'}
def require(condition,message):
    if not condition:raise RuntimeError(message)

@contextmanager
def cluster(work,pg,env):
    data=work/'cluster';sock=work/'socket';sock.mkdir(mode=0o700)
    subprocess.run([str(pg/'initdb'),'-D',str(data),'-U','demo_admin','-A','trust','--no-locale','-E','UTF8'],env=env,check=True,capture_output=True)
    started=False
    try:
        started=True
        subprocess.run([str(pg/'pg_ctl'),'-D',str(data),'-l',str(work/'server.log'),'-o',f"-k {sock} -p 55481 -c listen_addresses=''",'-w','start'],env=env,check=True,capture_output=True)
        yield dict(env,PGHOST=str(sock),PGPORT='55481',PGUSER='demo_admin')
    finally:
        if started and (data/'postmaster.pid').exists():subprocess.run([str(pg/'pg_ctl'),'-D',str(data),'-m','fast','-w','stop'],env=env,check=True,capture_output=True)

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('suite',choices=['all',*SUITES]);ap.add_argument('--output',type=Path,help='New private result directory; must not already exist')
    ap.add_argument('--pg-bin',type=Path,default=Path('/usr/lib/postgresql/16/bin'))
    args=ap.parse_args();pg=args.pg_bin.resolve()
    require(os.name=='posix' and os.geteuid()!=0,'Use a non-root Linux/WSL account.')
    require(not sys.flags.optimize,'Assertions must remain enabled; do not use Python -O.')
    for name in ['initdb','pg_ctl','psql','createdb','dropdb','pg_dump','pg_restore','pg_basebackup','pg_verifybackup']:
        require((pg/name).is_file(),f'Missing {name}; use --pg-bin to select PostgreSQL 16 server tools.')
    version=subprocess.check_output([str(pg/'postgres'),'--version'],text=True).strip()
    require(re.search(r'\b16\.',version),'These examples are verified for PostgreSQL 16; use its server tools.')
    if args.suite in ['all','lifecycle']:
        try:import psycopg2
        except ImportError:raise RuntimeError('Use the course Python environment containing psycopg2-binary 2.9.10.')
    out=(args.output or ROOT.parent/'.local/textbook-companion'/dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')).resolve()
    require(not out.exists(),'Choose a new result directory; existing evidence is preserved.')
    out.mkdir(parents=True,mode=0o700)
    # Ignore inherited database targets and demo credentials. Only freshly created clusters are used.
    env={k:v for k,v in os.environ.items() if not k.startswith(('PG','EDS_'))}
    env.update(PATH=str(Path(sys.executable).parent)+os.pathsep+str(pg)+os.pathsep+env.get('PATH',''),LC_ALL='C.UTF-8',PG_BIN=str(pg),PG_BINDIR=str(pg),EDS_PRIVATE_RUN='1',EDS_SQL_ONLY='1')
    for role in ['ANALYST','STEWARD','AUDITOR','SERVICE','ROTATED']:env['EDS_DEMO_'+role+'_PASSWORD']=secrets.token_urlsafe(30)
    selected=list(SUITES) if args.suite=='all' else [args.suite]
    report={'started_at_utc':dt.datetime.now(dt.timezone.utc).isoformat(),'postgresql':version,'python':sys.version.split()[0],'suites':[],'scope':'Synthetic local demonstrations; no production, human pilot, fresh OS installation or independent disaster recovery claim.'}
    hashes={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in ROOT.rglob('*') if p.is_file() and p.suffix in ['.py','.sh','.sql','.csv','.jsonl'] and '__pycache__' not in p.parts}
    (out/'executed_source_hashes.json').write_text(json.dumps(hashes,indent=2))
    for suite in selected:
        print('Running '+suite+': '+SUITES[suite],flush=True);start=time.monotonic();rec={'suite':suite,'status':'FAIL'}
        dest=out/suite;dest.mkdir()
        try:
            with tempfile.TemporaryDirectory(prefix='eds-companion-') as td:
                work=Path(td);src=work/'examples';shutil.copytree(ROOT/'examples'/suite,src)
                runenv=dict(env,EDS_RESULT_DIR=str(dest))
                with (dest/'execution.log').open('w') as log:
                    def run(cmd,e=runenv):subprocess.run(cmd,cwd=src,env=e,stdout=log,stderr=subprocess.STDOUT,check=True)
                    if suite in ['foundations','transactions']:
                        with cluster(work,pg,runenv) as e:
                            if suite=='foundations':
                                run(['bash','run_all.sh',str(dest/'transcript.txt')],e)
                                transcript=(dest/'transcript.txt').read_text()
                                require('# OVERALL: PASS (SQL-ONLY:' in transcript,'Foundation assertions failed.')
                                rec['assertions']=int(re.search(r'# Assertions passed: (\d+)',transcript)[1])
                                rec['scope']='SQL assertions; printed manuscript listing equivalence is a separate editorial check.'
                            else:
                                run(['bash','run_all.sh'],e);shutil.copy2(src/'validation_transcript.txt',dest/'transcript.txt')
                                run([sys.executable,'check_observations.py',str(dest/'transcript.txt')],e)
                                rec['scope']='Recorded outcomes and forced two-session schedules; not all possible interleavings.'
                    elif suite=='lifecycle':
                        run(['bash','run_all.sh',str(dest/'transcript.txt')])
                        transcript=(dest/'transcript.txt').read_text();require('# OVERALL: PASS' in transcript,'Lifecycle suite failed.')
                        rec['assertions']=int(re.search(r'Assertions passed: (\d+)',transcript)[1])
                    else:
                        for script in ['verify_package.py','verify_early_examples.py']:run([sys.executable,'shared/python/'+script])
                rec['status']='PASS'
        except Exception as exc:
            rec['error_type']=type(exc).__name__
            print(suite+' failed; inspect its private execution log.',file=sys.stderr)
        rec['elapsed_seconds']=round(time.monotonic()-start,3);report['suites'].append(rec)
        report['status']='PASS' if all(r['status']=='PASS' for r in report['suites']) else 'FAIL'
        (out/'summary.json').write_text(json.dumps(report,indent=2))
        print(suite+': '+rec['status'],flush=True)
    print('Private results: '+str(out))
    return 0 if report['status']=='PASS' else 1
if __name__=='__main__':
    try:raise SystemExit(main())
    except RuntimeError as exc:print(str(exc),file=sys.stderr);raise SystemExit(2)
