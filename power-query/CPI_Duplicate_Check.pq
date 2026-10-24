let
    Source = CPI_Monthly,
    #"Grouped Rows" = Table.Group(Source, {"series_id", "Date"}, {{"Count", each Table.RowCount(_), Int64.Type}})
in
    #"Grouped Rows"
