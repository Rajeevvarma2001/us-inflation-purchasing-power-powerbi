let
    Source = Fact_CPI,
    #"Grouped Rows" = Table.Group(Source, {"area_code"}, {{"Record_Count", each Table.RowCount(_), Int64.Type}}),
    #"Sorted Rows" = Table.Sort(#"Grouped Rows",{{"Record_Count", Order.Descending}})
in
    #"Sorted Rows"
