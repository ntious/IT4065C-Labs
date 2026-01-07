# Lab 1: Preflight & Environment Readiness
Course: IT4065C – Data Technologies Administration
Repository: https://github.com/ntious/IT4065C-Labs
Time Required: ≤ 2 hours
Environment: Individual Ubuntu VM (VMware Cloud Services)
________________________________________
## Goal of Lab 1
By the end of this lab, you will be able to:
1.	Log into your Ubuntu virtual machine
2.	Clone the course GitHub repository
3.	Install PostgreSQL locally on your VM
4.	Install dbt for PostgreSQL
5.	Configure dbt to connect to a local database
6.	Run dbt debug successfully
7.	Run basic SQL queries against a local database
Note:
No transformations, no modeling, and no dbt run are required in this lab.
________________________________________
## Step 1: Log into Your Ubuntu VM
1.	Log into your UC Sandbox Ubuntu VM at:
https://range.ocri.io
2.	Open a terminal window.
3.	Confirm the operating system by running:
4.	lsb_release -a
You should see Ubuntu 20.04 or 22.04.
If the VM does not load correctly, stop and contact your instructor or IT support.
________________________________________
## Step 2: Update System Packages
1.	Run the following commands once:
sudo apt update
sudo apt upgrade -y
This helps prevent package conflicts later.
________________________________________
## Step 3: Install Required System Tools
1.	Install Git, Python, and PostgreSQL:
sudo apt install -y git python3 python3-pip postgresql postgresql-contrib
2.	Verify each installation:
git --version
python3 --version
psql --version
Each command should return a version number.
________________________________________
## Step 4: Start and Verify PostgreSQL
1.	Check PostgreSQL service status:
sudo systemctl status postgresql
You should see active (running).
2.	Switch to the postgres user:
sudo -i -u postgres
3.	Open the PostgreSQL shell:
psql
4.	Exit PostgreSQL:
\q
5.	Exit the postgres user:
exit
________________________________________
## Step 5: Create Your Local Course Database and Schema
1.	From your normal Ubuntu user account, run:
sudo -u postgres createdb it4065c
sudo -u postgres psql it4065c
2.	Inside PostgreSQL, run:
CREATE SCHEMA raw;
CREATE SCHEMA student_kofi;
\q
This simulates schema-level governance isolation used later in the course.
________________________________________
## Step 6: Clone the Course GitHub Repository
1.	From your home directory:
cd ~
git clone https://github.com/ntious/IT4065C-Labs.git
cd IT4065C-Labs
2.	Confirm the repository structure:
ls
You should see the following folders:
•	docs
•	labs
•	dbt
📸 Screenshot 1:
Take a screenshot showing the repository structure (docs, labs, dbt).
________________________________________
## Step 7: Install dbt for PostgreSQL
1.	Install dbt:
pip3 install dbt-postgres
2.	Verify installation:
dbt --version
You must see the Postgres adapter listed.
________________________________________
## Step 8: Configure dbt profiles.yml
Step 8.1: Create dbt Configuration Directory
mkdir -p ~/.dbt
Step 8.2: Copy the Profile Template
cp dbt/it4065c_platform/profiles_template.yml ~/.dbt/profiles.yml
Step 8.3: Edit profiles.yml
1.	Open the file:
nano ~/.dbt/profiles.yml
2.	Update it as follows:
it4065c_platform:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password:
      port: 5432
      dbname: it4065c
      schema: student_kofi
      threads: 2
Note:
If your VM uses peer authentication, leaving password blank is expected.
Save and exit: CTRL + O, ENTER, CTRL + X.
________________________________________
## Step 9: Run dbt debug
1.	Navigate to the dbt project directory:
cd dbt/it4065c_platform
2.	Run:
dbt debug
Success Criteria
You must see:
•	Profile loaded successfully
•	Connection test: OK
If this fails, consult docs/troubleshooting.md.
📸 Screenshot 2:
Take a screenshot showing successful dbt debug.
________________________________________
## Step 10: Run Basic SQL Queries
1.	Open PostgreSQL:
psql it4065c
2.	Run:
SELECT schema_name
FROM information_schema.schemata;

SELECT current_schema;
Then run:
CREATE TABLE student_kofi.test_table (id INT);
INSERT INTO student_kofi.test_table VALUES (1), (2);
SELECT COUNT(*) FROM student_kofi.test_table;
3.	Exit PostgreSQL:
\q
📸 Screenshot 3:
Take a screenshot showing the SELECT COUNT(*) result.
________________________________________
## Step 11: Lab 1 Deliverables
Submit one MS Word or PDF file on Canvas containing:
1.	Screenshot 1: Repository structure (docs, labs, dbt)
2.	Screenshot 2: Successful dbt debug output
3.	Screenshot 3: SELECT COUNT(*) query output
4.	Short reflection (2–4 sentences):
What schema am I responsible for, and why does schema isolation matter in governed data systems?

