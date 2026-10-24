let
    Source = CPI_Monthly,
    #"Merged Queries" = Table.NestedJoin(Source, {"series_id"}, #"raw cpi_series", {"series_id"}, "raw cpi_series", JoinKind.LeftOuter),
    #"Expanded raw cpi_series" = Table.ExpandTableColumn(#"Merged Queries", "raw cpi_series", {"area_code", "item_code", "seasonal", "series_title"}, {"area_code", "item_code", "seasonal", "series_title"})
in
    #"Expanded raw cpi_series"
