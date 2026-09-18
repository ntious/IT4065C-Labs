"""Rehearse every lab twice and challenge failure behavior on a disposable course DB.

Run after setup. Requires the unmodified synthetic fixture, never real data.
Changes one fixture value briefly to establish that quality tests really fail.
"""
import json
import os
from pathlib import Path
from unittest.mock import patch
from course import Course, ROOT, require


def main():
    course = Course()
    with patch.dict(os.environ, {"PGHOSTADDR": "192.0.2.1", "PGSERVICE": "must_not_be_used"}):
        course.preflight()
    print("PASS: ambient libpq settings cannot redirect the runtime connection.")
    for attempt in (1, 2):
        for number in range(1, 10):
            course.run(number)
        print(f"PASS: full sequence, attempt {attempt}.")

    for role in ("analyst", "steward"):
        queries = [course.sql.SQL("CREATE TABLE {}.unexpected_write(id integer)").format(course.sql.Identifier(course.schema)),
                   "UPDATE raw.customers SET email='forbidden@example.com' WHERE false"]
        for query in queries:
            try:
                course.execute(query, role=role)
            except course.pg.Error as error:
                require(error.pgcode == "42501", "Write denial was not authorization enforcement.")
            else:
                raise ValueError("Reader unexpectedly had write/create privileges.")
    print("PASS: reader write and schema-create denials.")

    # Repeated helpers must not retain database connections.
    baseline = course.execute("SELECT count(*) FROM pg_stat_activity WHERE datname=current_database()")[0][0]
    for _ in range(20):
        course.execute("SELECT 1")
    after = course.execute("SELECT count(*) FROM pg_stat_activity WHERE datname=current_database()")[0][0]
    require(after <= baseline + 1, "Repeated calls leaked connections.")
    print("PASS: connections are released.")

    # Verify a genuine failing quality check, then restore the exact prior value.
    row = course.execute("SELECT order_item_id,quantity FROM raw.order_items ORDER BY order_item_id LIMIT 1")[0]
    try:
        course.execute("UPDATE raw.order_items SET quantity=0 WHERE order_item_id=%s", (row[0],))
        try:
            course.lab3()
        except ValueError:
            results = json.loads((ROOT / "dbt/it4065c_platform/target/run_results.json").read_text())["results"]
            require(any(r["status"] == "fail" and "positive_line_values" in r["unique_id"] for r in results),
                    "Injected invalid quantity did not produce the expected data-test failure.")
        else:
            raise ValueError("Invalid fixture incorrectly passed dbt checks.")
    finally:
        course.execute("UPDATE raw.order_items SET quantity=%s WHERE order_item_id=%s", (row[1], row[0]))
    course.lab3()
    print("PASS: invalid data fails quality checks; restored data passes.")

    notebook = json.loads((ROOT / "notebooks/MetaData_Lab_StepByStep.ipynb").read_text())
    namespace = {}
    for cell in notebook["cells"]:
        if cell["cell_type"] == "code":
            exec(compile("".join(cell["source"]), "metadata-notebook", "exec"), namespace)
    print("PASS: metadata notebook executes from a clean namespace.")
    print("VERIFICATION COMPLETE: nine labs twice, negative controls, recovery and notebook.")


if __name__ == "__main__":
    main()
