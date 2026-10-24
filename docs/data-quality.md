# Data quality checks

Government data is reliable, but it isn't perfectly clean. Before building any measure, the model
tests the data with one Power Query table per check. Because they're part of the model, they re-run
on every refresh.

| Check table | Rule | Result |
|---|---|---|
| `CPI_Duplicate_Check` | One row per `series_id` + month | ✅ No duplicates (max 1 row per pair across 875,488 rows) |
| `CPI_Missing_Value_Check` | Value is blank or `-` | ⚠️ 2,753 rows, **all October 2025**, footnote `X` |
| `CPI_Invalid_Value_Check` | Value is ≤ 0 | ✅ 0 rows |
| `CPI_Unmatched_Series_Check` | Observation has a series in the catalogue | ✅ 0 orphans |
| `CPI_Seasonal_Check` | Seasonal flag distribution | 7,778 `U` · 326 `S` |
| `CPI_Area_Check` | Rows per area code | 58 areas; `0000` (U.S.) has 240,878 rows |
| `CPI_Category_Check` | Series per item, joined to item names | 400 items, all matched |
| `CPI_National_Check` | Filter to `0000` / `SA0` / `U` | Exactly one series: `CUUR0000SA0` |
| `CPI_National_Date_Check` | First / last month, row count | Jan 1997 – Sep 2026, 357 months, no gaps |
| `Fact_CPI_RowCount_Check` | Rows in the cleaned fact | 875,488 |

## The October 2025 gap
BLS did not publish CPI for October 2025, and the source files mark every series for that month
with `-` and footnote `X`. The pipeline tags those rows **Missing** and leaves them out of the
calculations. Filling them in (for example with an average of September and November) would invent
data that doesn't exist.

## Re-running the checks in SQL
[`sql/04_data_quality_checks.sql`](../sql/04_data_quality_checks.sql) runs the same rules directly in
PostgreSQL, so problems can be caught before Power BI refreshes.
