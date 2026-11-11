"""Check the material outcomes in the transaction demonstration transcript.
Expected SQL errors are part of the examples; a zero shell status alone is insufficient.
"""
from pathlib import Path
import re,sys
s=Path(sys.argv[1]).read_text();errors=[]
def check(label,condition):
    print(('PASS ' if condition else 'FAIL ')+label)
    if not condition:errors.append(label)
check('nine transaction schedules and two read-isolation schedules present',len(re.findall(r'^== ',s,re.M))==11)
cases=[('naive read-then-write, READ COMMITTED',2),('naive, REPEATABLE READ, no retry',1),('naive, REPEATABLE READ, literal retry',2),('conditional update + decision',1),('FOR UPDATE + decision',1),('FOR UPDATE, naive writer',1),('REPEATABLE READ + decision, retry',1)]
blocks=re.split(r'^== ',s,flags=re.M)[1:]
for name,count in cases:
    block=next((b for b in blocks if name in b.splitlines()[0]),'')
    check(name,'confirmed_sales='+str(count) in block and 'inventory=1:0' in block)
check('deadlock detected in opposing lock order','40P01' in s)
check('serialization conflict detected','40001' in s)
check('constraint backstop detected','23514' in s)
rc=next((b for b in blocks if b.startswith('READ COMMITTED')),'')
rr=next((b for b in blocks if b.startswith('REPEATABLE READ')),'')
check('read committed observes 10 then 7',bool(re.search(r'read[^\n]*10',rc)) and bool(re.search(r'read[^\n]*7',rc)))
check('repeatable read observes 10 twice',len(re.findall(r'read[^\n]*10',rr))==2)
check('grain comparison includes correct and incorrect amounts','219.93' in s and '139.95' in s)
rows=[tuple(x.strip() for x in line.split('|')) for line in s.splitlines() if '|' in line and not line.startswith('#')]
expected={
 'initial quality profile':('5','5','4','80.0','60.0','2','3','0'),
 'quality boundary and unknown date':('7','7','6','85.7','71.4','2','4','1'),
 'empty quality population':('0','0','0','','','0','0','0'),
 'duplicate candidate':('alice@example.com','{1,4}','2'),
 'invalid postal representation':('5','4522'),
 'price exception':('12','4.99','49.99'),
 'resolved identities':('5','4','0'),
 'inflated join':('219.93','4'),
 'line-grain derivation':('4','3','139.95'),
 'order-grain agreement':('139.95','139.95','3'),
 'missing child retained':('5','25.00','','','no lines'),
 'amount mismatch':('6','30.00','1','29.99','amount mismatch'),
 'orphan line':('99','42'),
 'historical category':('Home Goods','39.90'),
 'current category':('Outdoor','59.85'),
 'version fan-out':('6','159.60'),
 'inclusive date boundary':('103','2026-01-31','1','Home Goods'),
 'period-end balance':('35','2026-01-31','35','3','31','37.7'),
 'missing period end remains unknown':('','2026-01-30','38','2','31','39.0'),
 'missing interior day changes coverage':('35','2026-01-31','35','2','31','37.5'),
 'atomicity final state':('0','0','0','0','','1'),
 'stop-on-error autocommit final state':('1','1','1','0','pending','1'),
 'continue-on-error autocommit final state':('1','1','1','1','pending','1'),
 'completed order unchanged':('7001','2','completed'),
 'allowed pending update':('7002','4','pending'),
}
for label,row in expected.items():check(label,row in rows)
check('allowed delete removed row',not any(r and r[0]=='7003' for r in rows))
check('completed update and delete both rejected',s.count('ERROR:  order 7001 is completed and cannot be changed')==2)
check('reservation overlap rejected','conflicting key value violates exclusion constraint' in s)
check('adjacent reservation accepted',('1','["2026-11-10 12:00:00","2026-11-10 13:00:00")') in rows)
for name,inventory in [('Basket, consistent order','inventory=1:4 2:0'),('Basket, inconsistent order','inventory=1:4 2:4')]:
    block=next((b for b in blocks if b.startswith(name)),'')
    check(name,inventory in block and 'confirmed_sales=1' in block)
allowed=['violates check constraint','current transaction is aborted','order 7001 is completed','conflicting key value violates exclusion constraint','40001:','23514:','40P01:','P0001:']
unexpected=[line for line in s.splitlines() if 'ERROR:' in line and not any(x in line for x in allowed)]
check('all SQL errors have an expected cause',not unexpected)
check('no missing input or connection error',not re.search(r'No such file|command not found|could not connect|Permission denied',s))
if errors:raise SystemExit(1)
