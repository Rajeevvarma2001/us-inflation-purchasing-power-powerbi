-- Load the BLS CPI-U flat files into the raw schema.
--
-- 1. Download from https://download.bls.gov/pub/time.series/cu/ in a browser
--    (BLS blocks most scripted downloads):
--      cu.data.0.Current, cu.data.1.AllItems, cu.data.2.Summaries, cu.series, cu.item
-- 2. Put them in one folder and run from that folder:
--      psql -U postgres -d purchasing_power -f path/to/03_load_bls_files.sql
--
-- The files are tab-delimited with a header row.

\copy raw.cpi_current   FROM 'cu.data.0.Current'   WITH (FORMAT csv, DELIMITER E'\t', HEADER true, QUOTE E'\b')
\copy raw.cpi_data      FROM 'cu.data.1.AllItems'  WITH (FORMAT csv, DELIMITER E'\t', HEADER true, QUOTE E'\b')
\copy raw.cpi_summaries FROM 'cu.data.2.Summaries' WITH (FORMAT csv, DELIMITER E'\t', HEADER true, QUOTE E'\b')
\copy raw.cpi_series    FROM 'cu.series'           WITH (FORMAT csv, DELIMITER E'\t', HEADER true, QUOTE E'\b')
\copy raw.cpi_item      FROM 'cu.item'             WITH (FORMAT csv, DELIMITER E'\t', HEADER true, QUOTE E'\b')

-- BLS pads the key columns with spaces; trim them so joins work.
UPDATE raw.cpi_current   SET series_id = TRIM(series_id), period = TRIM(period);
UPDATE raw.cpi_data      SET series_id = TRIM(series_id), period = TRIM(period);
UPDATE raw.cpi_summaries SET series_id = TRIM(series_id), period = TRIM(period);
UPDATE raw.cpi_series    SET series_id = TRIM(series_id), area_code = TRIM(area_code),
                             item_code = TRIM(item_code), seasonal = TRIM(seasonal);
UPDATE raw.cpi_item      SET item_code = TRIM(item_code);

-- Row counts after load
SELECT 'cpi_current' AS table_name, COUNT(*) FROM raw.cpi_current
UNION ALL SELECT 'cpi_data',      COUNT(*) FROM raw.cpi_data
UNION ALL SELECT 'cpi_summaries', COUNT(*) FROM raw.cpi_summaries
UNION ALL SELECT 'cpi_series',    COUNT(*) FROM raw.cpi_series
UNION ALL SELECT 'cpi_item',      COUNT(*) FROM raw.cpi_item;
