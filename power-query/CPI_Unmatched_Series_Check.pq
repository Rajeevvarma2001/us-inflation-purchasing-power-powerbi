let
    Source = CPI_Monthly,
    #"Merged Queries" = Table.NestedJoin(Source, {"series_id"}, CPI_Monthly, {"series_id"}, "CPI_Monthly", JoinKind.LeftAnti)
in
    #"Merged Queries"
