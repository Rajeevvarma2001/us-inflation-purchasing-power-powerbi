let
    Source = #"raw cpi_current",
    #"Filtered Rows" = Table.SelectRows(Source, each ([period] <> "M13")),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows", "Date", each let
    y = try Number.From([year]) otherwise null,
    p = if [period] = null then ""
        else Text.Trim(Text.From([period])),
    m = try Number.FromText(Text.AfterDelimiter(p, "M"))
        otherwise null
in
    if y = null or m = null or m < 1 or m > 12
    then null
    else try #date(y, m, 1) otherwise null),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"Date", type date}}),
    #"Filtered Rows1" = Table.SelectRows(#"Changed Type", each Text.StartsWith([period], "M"))
in
    #"Filtered Rows1"
