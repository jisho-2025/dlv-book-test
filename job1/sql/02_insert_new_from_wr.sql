INSERT INTO m_sample (id, name, value)
SELECT s.id, s.name, s.value
FROM "wr_m_sample" s
WHERE NOT EXISTS (
  SELECT 1 FROM m_sample t WHERE t.id = s.id
);
