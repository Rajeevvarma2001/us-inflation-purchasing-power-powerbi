let
    Source = CPI_Monthly,
    #"Filtered Rows" = Table.SelectRows(Source, each [CPI_Value] <= 0)
in
    #"Filtered Rows"
