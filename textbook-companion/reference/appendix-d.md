# Appendix D
# dbt Quick Reference

dbt supports SQL-based transformation, dependency management, testing, and documentation. This appendix supports Chapters 6, 7, 10, and 16. The book's repository baseline pins dbt Core 1.11.2 and dbt-postgres 1.10.0; do not substitute a newer release merely because its online documentation is newer.

## D.1 Follow the course entry point

After the supported setup, run course activities from the repository root using the configured interpreter:

```bash
.venv/bin/python scripts/course.py lab 3
.venv/bin/python scripts/course.py lab 4
```

The runner prepares the course environment and selects the activity's work. Lab 3 builds and tests the layered models; Lab 4 develops lifecycle and lineage work around them. Inspect the complete result and any warnings. A successful run is evidence about the selected resources in that environment, not every possible model or every business rule.

The project is `dbt/it4065c_platform`. Its staging models are configured as views and its core and mart models as tables. The baseline contains ten models across these layers. A dbt “model” is a transformation resource; it is not an entity-relationship model or a trained machine-learning model.

## D.2 Read dependencies explicitly

| Expression or resource | Meaning | Important boundary |
| --- | --- | --- |
| `source('raw', 'orders')` | Reference a declared external source relation. | Declaration does not prove timely or complete delivery. |
| `ref('stg_orders')` | Resolve a model relation and declare a dependency. | Lineage covers declared dependencies, not every export or external use. |
| SQL model | Query used to construct a relation under its materialization. | A compiled query is not evidence of successful execution. |
| YAML properties | Descriptions, sources, tests, and other resource properties. | Descriptions can become stale; review them alongside behavior. |
| Materialization | How a model is represented or maintained. | View, table, incremental, and ephemeral designs have different effects. |

For example, the baseline staging model reads `source('raw', 'orders')` and normalizes the status with `lower(nullif(trim(order_status), ''))`. Raw `Completed` therefore becomes staged `completed`. Filtering the wrong representation can silently change a metric. This transformation standardizes representation; it does not prove that the source status was correct.

## D.3 Read a data test

The following extract illustrates the baseline's test syntax for `stg_orders`. It is a reference extract, not an instruction to add a duplicate model declaration:

```yaml
version: 2
models:
  - name: stg_orders
    columns:
      - name: order_id
        data_tests: [not_null, unique]
      - name: order_status
        data_tests:
          - accepted_values:
              arguments:
                values: [completed, cancelled]
```

The identifier tests look for nulls and duplicates. The accepted-values test checks the declared vocabulary. These checks do not establish that every expected order arrived, that the amount is accurate, or that a status transition was authorized. Do not assume an accepted-values or relationships test independently rejects nulls; specify a separate `not_null` requirement where needed.

A singular SQL data test normally returns rows that violate its assertion. In the usual default configuration, zero failing rows means pass; severity and failure thresholds can alter outcomes. Record the actual configuration, selected tests, failing rows or counts, and downstream consequence. Data tests detect conditions when run; they are not automatically database constraints preventing writes.

## D.4 Understand native commands before using them

The commands below describe dbt concepts. Direct execution requires the correct project, profile, adapter, environment variables, and target; for the course, prefer its runner rather than improvising those settings.

| Command | Main purpose | What success does not establish |
| --- | --- | --- |
| `dbt debug` | Check configuration and connection conditions. | Correct transformations or business permission. |
| `dbt ls` | List selected resources. | Their execution or correctness. |
| `dbt compile` | Render project resources to executable SQL. | That the resulting transformations succeeded. |
| `dbt run` | Execute selected models. | That every relevant data test passed. |
| `dbt test` | Execute selected tests. | Complete coverage of the requirement. |
| `dbt build` | Build and test selected resource types in dependency order. | One atomic transaction for the entire pipeline. |
| `dbt docs generate` | Produce project documentation artifacts. | Complete organizational lineage or approval. |

In selection expressions, a leading `+` includes ancestors and a trailing `+` includes descendants. Inspect selection before drawing conclusions about coverage. An error-level upstream test failure can cause dependent resources to be skipped during `build`; inspect resource-level statuses rather than counting only completed models.

## D.5 Preserve useful, private evidence

Keep the command, baseline, versions, target, selected resources, invocation time, row counts where relevant, test outcomes, warnings, and limitations. `manifest.json` describes project resources and dependencies; `run_results.json` records results for resources in that invocation. Neither independently records all source deliveries or downstream copies.

The course keeps configuration and generated outputs private, including `.local/dbt-last.log` and dbt target/log directories. The runner translates the private course password into `DBT_ENV_SECRET_DB_PASSWORD` for the profile. Do not paste passwords into YAML, publish connection profiles, or expose generated documentation indiscriminately. To view course documentation locally, use the documented `course.py docs` workflow and stop the server when finished.

## D.6 Companion evidence and dbt boundaries

Use `textbook-companion/CHAPTER_GUIDE.md` to find the related Chapter 7 and Chapter 10 activities. The optional reasoning suite substitutes a table name for dbt `ref` in selected SQL checks; that checks the SQL mechanism, not execution of a dbt project. The course runner remains the route for actual course dbt builds and documentation.

The supplied record in `textbook-companion/evidence/quality-failure.md` describes an earlier disposable rehearsal: a controlled zero quantity failed both `positive_line_values` and `order_reconciliation`; restoring the original value returned the ten models and 37 tests to successful results. Skipped resources are reported separately. This is attributed reference evidence, not proof of a reader's own run or an instruction to inject the defect during ordinary Lab 3. Inspect the stated revision, versions, scope and limits before reusing it.

## D.7 Sources and further reading

dbt Labs. (n.d.). dbt documentation: build; data tests; ref; source; env_var. https://docs.getdbt.com/reference/commands/build ; https://docs.getdbt.com/docs/build/data-tests ; https://docs.getdbt.com/reference/dbt-jinja-functions/ref ; https://docs.getdbt.com/reference/dbt-jinja-functions/source ; https://docs.getdbt.com/reference/dbt-jinja-functions/env_var . Select documentation appropriate to the installed version.

Nti, I. K. (2026). IT4065C-Labs: Data Technologies Administration [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602 . Repository: https://github.com/ntious/IT4065C-Labs . Sources: dbt/README.md, requirements.in, dbt_project.yml, and models/lab3/_lab3_models.yml at commit d860dd98256a8090ffc6bd3766c59cb15a553c12.
