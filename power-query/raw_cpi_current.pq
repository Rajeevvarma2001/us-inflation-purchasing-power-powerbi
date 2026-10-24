let
    Source = PostgreSQL.Database("localhost:5432", "purchasing_power"),
    raw_cpi_current = Source{[Schema="raw",Item="cpi_current"]}[Data],
    #"Added Custom" = Table.AddColumn(raw_cpi_current, "Value_Status", each let
    value = Text.Trim([value_text])
in
    if value = "" or value = "-" then "Missing"
    else if (try Number.FromText(value) otherwise null) = null
    then "Invalid"
    else "Valid"),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "CPI_Value", each let
    v = if [value_text] = null
        then ""
        else Text.Trim([value_text])
in
    if v = "" or v = "-"
    then null
    else try Number.FromText(v) otherwise null)
in
    #"Added Custom1"
