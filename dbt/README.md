# IT4065C dbt Project

This dbt project supports the semester-long Governed Analytics Data Platform project.

## Folder Structure
- `staging/` – cleaned and standardized source data
- `core/` – integrated business entities
- `marts/` – analytics-ready datasets

## Usage
From this directory:
```bash
dbt debug
dbt run
dbt test
