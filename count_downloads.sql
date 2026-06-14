WITH latest_packages AS (
  SELECT
    name AS package_name,
    version,
    upload_time,
    ROW_NUMBER() OVER (
      PARTITION BY name
      ORDER BY upload_time DESC
    ) AS rn
  FROM `bigquery-public-data.pypi.distribution_metadata`
  WHERE
    'Topic :: Scientific/Engineering'
    IN UNNEST(classifiers)
),

selected_packages AS (
  SELECT
    package_name,
    version,
    upload_time
  FROM latest_packages
  WHERE rn = 1
)

SELECT
  p.package_name,
  p.version,
  p.upload_time,
  COUNT(*) AS sampled_downloads_30d
FROM `bigquery-public-data.pypi.file_downloads` AS d
JOIN selected_packages p
  ON d.file.project = p.package_name
  AND d.file.version = p.version
WHERE
  DATE(d.timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY
  p.package_name,
  p.version,
  p.upload_time
ORDER BY sampled_downloads_30d DESC