# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
from __future__ import annotations

# The report checker deliberately focuses on structural readiness and evidence presence.
# Open-ended academic quality is always marked for instructor review.

SHARED_TEMPLATE_SECTIONS = [
    ("Lab and execution evidence", ["lab and execution evidence", "execution evidence"]),
    ("Prediction or initial expectation", ["prediction or initial expectation", "prediction", "initial expectation"]),
    ("Observed result and explanation", ["observed result and explanation", "observed result", "result and explanation"]),
    ("Investigation and independent transfer", ["investigation and independent transfer", "independent transfer", "investigation"]),
    ("Evidence limitations and questions", ["evidence limitations and questions", "evidence limitation", "limitations and questions"]),
    ("Assistance and verification", ["assistance and verification", "assistance disclosure", "recovery and assistance"]),
]

LAB_SPECS = {
    1: {
        "title": "Environment readiness",
        "sections": [
            ("Setup evidence", ["setup evidence"]),
            ("Configuration path", ["configuration path"]),
            ("Three short explanations", ["three short explanations"]),
            ("Assistance disclosure", ["assistance disclosure", "assistance and verification"]),
        ],
        "required_any": [
            ("Connection PASS evidence", ["pass: connection, dedicated database"]),
            ("dbt debug PASS evidence", ["pass: dbt debug"]),
            ("Private configuration concept", [".env", "private env configuration"]),
            ("PostgreSQL identity endpoint", ["postgresql"]),
            ("Explanation 3.1", ["3.1", "ubuntu account and database login"]),
            ("Explanation 3.2", ["3.2", "schema name and permission"]),
            ("Explanation 3.3", ["3.3", "dbt debug establishes", "what dbt debug"]),
        ],
        "review": [
            "Instructor reviews the three explanations for accuracy and evidence limits.",
        ],
    },
    2: {
        "title": "Classification and stewardship",
        "sections": SHARED_TEMPLATE_SECTIONS,
        "required_any": [
            ("Lab 2 command or execution evidence", ["scripts/course.py lab 2", "pass: governance register"]),
            ("Guided-row verification", ["customers.created_at", "created_at"]),
            ("Rerun or preservation evidence", ["rerun", "survives", "preserved", "unchanged after"]),
            ("Alternative-classification discussion", ["alternative classification", "different classification", "changed purpose", "changed exposure", "changed harm"]),
        ],
        "custom": ["lab2_two_fields", "lab2_classification_terms"],
        "review": [
            "Instructor reviews whether both field classifications form a defensible field → purpose → harm → classification chain.",
            "Instructor reviews retention, accountable role, permitted use, and the alternative-classification rationale.",
        ],
    },
    3: {
        "title": "Modeling and data quality",
        "sections": SHARED_TEMPLATE_SECTIONS,
        "required_any": [
            ("Lab 3 command or build evidence", ["scripts/course.py lab 3", "pass: 10 models"]),
            ("Revenue reconciliation", ["139.95"]),
            ("Cancelled-order discussion", ["cancelled", "canceled", "cancellation"]),
            ("Guided test name", ["lab3_guided_daily_orders"]),
            ("Independent test name", ["lab3_my_sales_rule"]),
            ("Independent-test limitation", ["limitation", "does not prove", "does not establish"]),
        ],
        "local_checks": ["lab3_local_artifacts"],
        "review": [
            "Instructor reviews the grain/join explanation, revenue reasoning, independent test rule, and evidence limitation.",
        ],
    },
    4: {
        "title": "Lifecycle and lineage",
        "sections": [
            ("Section 0: execution evidence and prediction", ["0. execution evidence and prediction", "execution evidence and prediction"]),
            ("Section 1: lineage inspected", ["1. record the lineage you inspected", "lineage you inspected", "record the lineage"]),
            ("Section 2: lifecycle stages", ["2. explain each lifecycle stage", "explain each lifecycle stage", "lifecycle stage"]),
            ("Section 3: retention reasoning", ["3. reason about retention", "reason about retention"]),
            ("Section 4: assistance disclosure", ["4. assistance disclosure", "assistance disclosure"]),
        ],
        "required_any": [
            ("Sales lineage path", ["raw.orders -> stg_orders -> fct_orders -> olap_sales_by_day"]),
            ("Detail lineage path", ["raw.orders -> stg_orders -> fct_orders -> order_detail_mart"]),
            ("Named dependency expression", ["ref(", "source("]),
            ("Staging stage", ["staging", "stg_orders"]),
            ("Core stage", ["core", "fct_orders"]),
            ("Marts stage", ["marts", "olap_sales_by_day"]),
            ("Retention question 1", ["which copies could remain", "copies could remain"]),
            ("Retention question 2", ["refresh and verify", "what would you refresh"]),
            ("Retention question 3", ["graph not prove", "graph not prevent", "what does the graph not"]),
        ],
        "review": [
            "Instructor reviews the lifecycle-stage explanations, proposed versus observed controls, retention reasoning, and DAG limitation.",
        ],
    },
    5: {
        "title": "Access control and masking",
        "sections": [
            ("A1: Technical evidence", ["a1: technical evidence", "technical evidence"]),
            ("A2: Analyst sales", ["a2: analyst sales", "analyst sales"]),
            ("A3: Analyst masked customers", ["a3: analyst masked customers", "analyst masked customers"]),
            ("A4: Steward masked customers", ["a4: steward masked customers", "steward masked customers"]),
            ("Authorization evidence", ["authorization evidence"]),
            ("Proposed weekly-sales view", ["proposed weekly-sales view", "weekly-sales view", "weekly sales view"]),
            ("Remote-server discussion", ["remote-server discussion", "remote server discussion"]),
            ("Evidence limitation", ["evidence limitation"]),
            ("Recovery and assistance", ["recovery and assistance", "assistance disclosure", "assistance and verification"]),
        ],
        "required_any": [
            ("Lab 5 execution evidence", ["scripts/course.py lab 5", "nine access checks"]),
            ("Expected authorization denial", ["42501", "permission denied"]),
            ("Proposed status for new view", ["proposed"]),
        ],
        "local_checks": ["lab5_access_evidence"],
        "review": [
            "Instructor reviews grants versus projection reasoning, masking residual risk, view minimization, remote-server controls, and the evidence limitation.",
        ],
    },
    6: {
        "title": "Monitoring and evidence",
        "sections": SHARED_TEMPLATE_SECTIONS + [
            ("Incident memo: Evidence", ["incident memo", "evidence"]),
            ("Incident memo: Detection limits", ["detection limits"]),
            ("Incident memo: Response and ownership", ["response and ownership"]),
        ],
        "required_any": [
            ("Lab 6 command or monitoring evidence", ["scripts/course.py lab 6", "live permission evidence"]),
            ("Live allow evidence", ["00000", "allowed", "live allowed"]),
            ("Live denial evidence", ["42501", "permission denied", "live denied"]),
            ("Simulated finding", ["repeated_denial", "role_switch", "after_hours_export"]),
            ("Evidence-source distinction", ["live_client", "live client", "simulated", "fixture"]),
        ],
        "custom": ["lab6_simulated_not_observed"],
        "local_checks": ["lab6_audit_report"],
        "review": [
            "Instructor reviews the rule explanation, false-positive scenario, missed-incident scenario, stronger evidence source, and ownership proposal.",
        ],
    },
    7: {
        "title": "AI ethics and governance",
        "sections": SHARED_TEMPLATE_SECTIONS + [
            ("Worksheet section 1: Metric interpretation", ["metric interpretation"]),
            ("Worksheet section 2: Initial governance decision", ["initial governance decision"]),
            ("Lifecycle: Collection and curation", ["collection and curation"]),
            ("Lifecycle: Storage and access", ["storage and access"]),
            ("Lifecycle: Preparation and evaluation", ["preparation and evaluation"]),
            ("Lifecycle: Use and disclosure", ["use and disclosure"]),
            ("Lifecycle: Monitoring and change", ["monitoring and change"]),
            ("Lifecycle: Retirement", ["retirement"]),
            ("NIST Govern", ["govern:", "govern "] ),
            ("NIST Map", ["map:", "map "] ),
            ("NIST Measure", ["measure:", "measure "] ),
            ("NIST Manage", ["manage:", "manage "] ),
            ("Worksheet section 3: Required change review", ["required change review", "change review"]),
        ],
        "required_any": [
            ("Lab 7 command or metric evidence", ["scripts/course.py lab 7", "ai metrics calculated"]),
            ("Group-B FNR calculation", ["3 / 4", "3/4", "0.75"]),
            ("False-negative tradeoff", ["false negative", "false-negative", "fnr"]),
            ("False-positive tradeoff", ["false positive", "false-positive", "fpr"]),
            ("Changed purpose", ["restrict refunds", "refund restriction", "refunds"]),
        ],
        "local_checks": ["lab7_ai_evaluation", "lab7_default_worksheet"],
        "review": [
            "Instructor reviews all Lab 7 rubric dimensions: lifecycle, bias/limitations, mitigation tradeoffs, transparency, and accountability/framework application.",
        ],
    },
}

LAB2_ALLOWED_INDEPENDENT_FIELDS = {
    "customer_id", "first_name", "last_name", "phone_number",
    "order_id", "order_date", "order_status", "payment_method",
}

CLASSIFICATION_TERMS = {"public", "internal", "sensitive", "restricted"}
