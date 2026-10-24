let
    Source = #"raw cpi_series",
    #"Grouped Rows" = Table.Group(Source, {"item_code"}, {{"Series_Count", each Table.RowCount(_), Int64.Type}}),
    #"Sorted Rows" = Table.Sort(#"Grouped Rows",{{"Series_Count", Order.Descending}}),
    #"Merged Queries" = Table.NestedJoin(#"Sorted Rows", {"item_code"}, #"raw cpi_item", {"item_code"}, "raw cpi_item", JoinKind.LeftOuter),
    #"Expanded raw cpi_item" = Table.ExpandTableColumn(#"Merged Queries", "raw cpi_item", {"item_code", "item_name", "display_level", "selectable", "sort_sequence"}, {"raw cpi_item.item_code", "raw cpi_item.item_name", "raw cpi_item.display_level", "raw cpi_item.selectable", "raw cpi_item.sort_sequence"})
in
    #"Expanded raw cpi_item"
