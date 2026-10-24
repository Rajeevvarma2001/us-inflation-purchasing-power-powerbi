let
    Source = CPI_Monthly,
    #"Filtered Rows" = Table.SelectRows(Source, each ([CPI_Value] = null))
in
    #"Filtered Rows"
