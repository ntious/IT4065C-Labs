# Week 1 — Preflight & Environment Readiness

## Goal
Confirm that you can connect to the course PostgreSQL sandbox and that dbt is working locally.

## Tasks (≤ 2 hours)
1) Connect to PostgreSQL using one method:
- psql, OR
- pgAdmin, OR
- VS Code SQL extension

2) Run these SQL queries (capture results):
- List tables in the raw schema
- Count rows in at least one raw table

3) Set up dbt locally:
- Install `dbt-postgres`
- Configure your `profiles.yml` using the provided template
- Run `dbt debug`

## Deliverables (submit in Canvas)
- Screenshot or log showing successful DB connection
- Output of `dbt debug`
- 3–5 sentence reflection: "What schema am I responsible for and why does schema isolation matter?"
