let
    Source = Fact_CPI,
    #"Counted Rows" = Table.RowCount(Source)
in
    #"Counted Rows"
