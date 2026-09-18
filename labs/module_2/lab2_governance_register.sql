CREATE TABLE IF NOT EXISTS {{schema}}.data_classification_register (
 table_name text NOT NULL,column_name text NOT NULL,classification text NOT NULL
 CHECK (classification IN ('Public','Internal','Sensitive','Restricted')),
 rationale text NOT NULL,owner_role text NOT NULL,retention_rule text NOT NULL,
 ai_use text NOT NULL,PRIMARY KEY(table_name,column_name));
