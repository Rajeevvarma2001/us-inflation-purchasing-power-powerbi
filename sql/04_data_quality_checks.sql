-- SQL versions of the validation tables built in Power Query.
-- Useful to check the data in PostgreSQL before refreshing Power BI.

\connect purchasing_power

-- Monthly observations only (drop M13 annual averages and half-year periods)
CREATE OR REPLACE VIEW raw.v_cpi_monthly AS
SELECT series_id,
       year,
       period,
       value_text,
       footnote_codes,
       CASE
           WHEN TRIM(value_text) IN ('', '-')            THEN 'Missing'
           WHEN TRIM(value_text) ~ '^-?[0-9]+(\.[0-9]+)?$' THEN 'Valid'
           ELSE 'Invalid'
       END AS value_status,
       CASE WHEN TRIM(value_text) ~ '^-?[0-9]+(\.[0-9]+)?$'
            THEN TRIM(value_text)::NUMERIC END            AS cpi_value,
       MAKE_DATE(year, SUBSTRING(period FROM 2)::INT, 1)  AS obs_date
FROM raw.cpi_current
WHERE period ~ '^M(0[1-9]|1[0-2])$';

-- 1. Duplicates: more than one row per series and month (expected: 0 rows)
SELECT series_id, obs_date, COUNT(*) AS row_count
FROM raw.v_cpi_monthly
GROUP BY series_id, obs_date
HAVING COUNT(*) > 1;

-- 2. Missing values (BLS did not publish Oct 2025, footnote X)
SELECT year, period, footnote_codes, COUNT(*) AS missing_rows
FROM raw.v_cpi_monthly
WHERE value_status = 'Missing'
GROUP BY year, period, footnote_codes
ORDER BY year, period;

-- 3. Invalid values: non-numeric or <= 0 (expected: 0 rows)
SELECT *
FROM raw.v_cpi_monthly
WHERE value_status = 'Invalid' OR cpi_value <= 0;

-- 4. Observations with no matching series in the catalogue (expected: 0 rows)
SELECT m.series_id, COUNT(*) AS orphan_rows
FROM raw.v_cpi_monthly m
LEFT JOIN raw.cpi_series s ON s.series_id = m.series_id
WHERE s.series_id IS NULL
GROUP BY m.series_id;

-- 5. Seasonal vs. unadjusted series
SELECT seasonal, COUNT(*) AS series_count
FROM raw.cpi_series
GROUP BY seasonal;

-- 6. Rows per area
SELECT s.area_code, COUNT(*) AS record_count
FROM raw.v_cpi_monthly m
JOIN raw.cpi_series s ON s.series_id = m.series_id
GROUP BY s.area_code
ORDER BY record_count DESC;

-- 7. Headline series used in the dashboard:
--    All items, U.S. city average, not seasonally adjusted (CUUR0000SA0)
SELECT m.series_id,
       MIN(m.obs_date) AS earliest_date,
       MAX(m.obs_date) AS latest_date,
       COUNT(*)        AS total_records
FROM raw.v_cpi_monthly m
JOIN raw.cpi_series s ON s.series_id = m.series_id
WHERE s.area_code = '0000' AND s.item_code = 'SA0' AND s.seasonal = 'U'
  AND m.value_status = 'Valid'
GROUP BY m.series_id;
