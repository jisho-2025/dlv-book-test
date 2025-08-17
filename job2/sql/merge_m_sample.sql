MERGE INTO m_sample AS tgt
USING wr_m_sample AS src
ON tgt.id = src.id
WHEN MATCHED THEN
  UPDATE SET col1 = src.col1, col2 = src.col2, updated_at = now()
WHEN NOT MATCHED THEN
  INSERT (id, col1, col2, created_at, updated_at)
  VALUES (src.id, src.col1, src.col2, now(), now());
