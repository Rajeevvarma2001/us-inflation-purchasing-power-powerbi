let
    Source = #"raw cpi_series",
    #"Grouped Rows" = Table.Group(Source, {"seasonal"}, {{"Record_Count", each Table.RowCount(_), Int64.Type}})
in
    #"Grouped Rows"
