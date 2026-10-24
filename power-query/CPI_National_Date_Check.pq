let
    Source = CPI_National_Check,
    #"Grouped Rows" = Table.Group(Source, {"series_id"}, {{"Earliest_Date", each List.Min([Date]), type nullable date}, {"Latest_Date", each List.Max([Date]), type nullable date}, {"Total_Records", each Table.RowCount(_), Int64.Type}})
in
    #"Grouped Rows"
