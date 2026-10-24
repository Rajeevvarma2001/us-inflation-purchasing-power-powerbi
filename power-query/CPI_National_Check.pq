let
    Source = Fact_CPI,
    #"Filtered Rows" = Table.SelectRows(Source, each ([area_code] = "0000") and ([item_code] = "SA0") and ([seasonal] = "U"))
in
    #"Filtered Rows"
