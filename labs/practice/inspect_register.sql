-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
SELECT table_name,column_name,classification,rationale,owner_role,retention_rule,ai_use
FROM {{schema}}.data_classification_register ORDER BY table_name,column_name;
