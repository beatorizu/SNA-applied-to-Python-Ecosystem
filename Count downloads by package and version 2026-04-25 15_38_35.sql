WITH downloads_filtered AS (
  SELECT *
  FROM `bigquery-public-data.pypi.file_downloads`
  WHERE DATE(timestamp) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    AND CURRENT_DATE()
)

SELECT 
  name,
  COUNT(*) AS num_downloads
FROM `bigquery-public-data.pypi.distribution_metadata` m
JOIN downloads_filtered d
  ON m.name = d.project
WHERE 
  'Topic :: Scientific/Engineering :: Quantum Computing' IN UNNEST(m.classifiers)
GROUP BY name
ORDER BY num_downloads DESC