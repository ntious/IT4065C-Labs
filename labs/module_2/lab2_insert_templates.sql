-- Worked examples, not answers to the independent classification task.
INSERT INTO {{schema}}.data_classification_register VALUES
 ('customers','email','Sensitive','Contact identifier; exclude from public analytics.',
 'Customer Data','Delete when purpose ends, subject to approved holds.','Not permitted as a model feature.'),
 ('orders','total_amount','Sensitive','Reveals commercial activity.',
 'Sales Operations','Scenario retention policy; verify applicable requirements.','Aggregate analysis only.')
ON CONFLICT (table_name,column_name) DO NOTHING;
