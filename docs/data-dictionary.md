# Data dictionary

## PostgreSQL – `purchasing_power.raw`

### `cpi_current`, `cpi_data`, `cpi_summaries` (observations)
| Column | Type | Description |
|---|---|---|
| `series_id` | text | BLS series code, e.g. `CUUR0000SA0` |
| `year` | integer | Observation year |
| `period` | text | `M01`–`M12` month, `M13` annual average, `S01`–`S03` half-year |
| `value_text` | text | Index value as published; `-` when not available |
| `footnote_codes` | text | BLS footnote, e.g. `X` = data unavailable |

### `cpi_series` (series catalogue)
| Column | Description |
|---|---|
| `series_id` | Primary key |
| `area_code` | Geography (`0000` = U.S. city average) |
| `item_code` | Spending category (`SA0` = all items) |
| `seasonal` | `S` seasonally adjusted, `U` not adjusted |
| `periodicity_code` | `R` monthly, `S` semi-annual |
| `base_code`, `base_period` | Index base, e.g. `1982-84=100` |
| `series_title` | Readable name |
| `begin_year`, `begin_period`, `end_year`, `end_period` | Coverage |

### `cpi_item`
| Column | Description |
|---|---|
| `item_code` | Primary key |
| `item_name` | Category name, e.g. "Cereals and bakery products" |
| `display_level` | Depth in the BLS category tree |
| `selectable` | `T` if selectable in BLS tools |
| `sort_sequence` | BLS display order |

## Power BI model

### `Fact_CPI` (875,488 rows)
Monthly observations for every series: the raw columns plus
`Value_Status` (Valid / Missing / Invalid), `CPI_Value` (number), `Date` (first of month),
and `area_code`, `item_code`, `seasonal`, `series_title` from the catalogue.

### `Fact_National_CPI` (357 rows)
| Column | Description |
|---|---|
| `series_id` | Always `CUUR0000SA0` |
| `Date` | First day of the month, Jan 1997 – Sep 2026 |
| `CPI_Value` | Index value (1982-84 = 100) |

### `Dim_Date` (calculated)
`Date`, `Year`, `Month Number`, `Month Name`, `Year-Month`, covering the range of `Fact_National_CPI`.

### `Historical Amount` (what-if parameter)
`GENERATESERIES(0, 10000, 100)`: the amount the reader converts into today's dollars.

### Validation tables
`CPI_Duplicate_Check`, `CPI_Missing_Value_Check`, `CPI_Invalid_Value_Check`, `CPI_Unmatched_Series_Check`,
`CPI_Seasonal_Check`, `CPI_Area_Check`, `CPI_Category_Check`, `CPI_National_Check`,
`CPI_National_Date_Check`, `Fact_CPI_RowCount_Check`. See [data-quality.md](data-quality.md).
