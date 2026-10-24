let
    Source = CPI_National_Check,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"series_id", "Date", "CPI_Value"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns",{{"CPI_Value", type number}})
in
    #"Changed Type"
