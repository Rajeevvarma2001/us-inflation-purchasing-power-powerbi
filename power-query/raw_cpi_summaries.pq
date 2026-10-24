let
    Source = PostgreSQL.Database("localhost:5432", "purchasing_power"),
    raw_cpi_summaries = Source{[Schema="raw",Item="cpi_summaries"]}[Data]
in
    raw_cpi_summaries
