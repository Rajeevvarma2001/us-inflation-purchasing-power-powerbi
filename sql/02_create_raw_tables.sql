-- Raw tables mirror the BLS "cu" (CPI-U) flat files column for column.
-- Observation values stay as TEXT on purpose: the source uses "-" for
-- months BLS did not publish, so typing and validation happen in Power Query.

\connect purchasing_power

DROP TABLE IF EXISTS raw.cpi_current, raw.cpi_data, raw.cpi_summaries,
                     raw.cpi_series, raw.cpi_item;

-- Observations (same layout for all three data files)
CREATE TABLE raw.cpi_current (      -- cu.data.0.Current   : all series, recent years
    series_id      TEXT,
    year           INTEGER,
    period         TEXT,             -- M01..M12 = months, M13 = annual average, S01..S03 = half-years
    value_text     TEXT,
    footnote_codes TEXT
);

CREATE TABLE raw.cpi_data (         -- cu.data.1.AllItems  : "All items" series, full history from 1913
    LIKE raw.cpi_current
);

CREATE TABLE raw.cpi_summaries (    -- cu.data.2.Summaries : headline summary series
    LIKE raw.cpi_current
);

-- Series catalogue: one row per series_id
CREATE TABLE raw.cpi_series (       -- cu.series
    series_id        TEXT PRIMARY KEY,
    area_code        TEXT,
    item_code        TEXT,
    seasonal         TEXT,           -- S = seasonally adjusted, U = unadjusted
    periodicity_code TEXT,
    base_code        TEXT,
    base_period      TEXT,
    series_title     TEXT,
    footnote_codes   TEXT,
    begin_year       INTEGER,
    begin_period     TEXT,
    end_year         INTEGER,
    end_period       TEXT
);

-- Item (category) lookup
CREATE TABLE raw.cpi_item (         -- cu.item
    item_code     TEXT PRIMARY KEY,
    item_name     TEXT,
    display_level TEXT,
    selectable    TEXT,
    sort_sequence INTEGER
);
