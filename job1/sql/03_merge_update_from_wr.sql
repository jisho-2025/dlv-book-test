MERGE INTO m_sample AS t
USING "wr_m_sample" AS s
  ON (t.id = s.id)
WHEN MATCHED THEN
  UPDATE SET
    name  = s.name,
    value = s.value;
