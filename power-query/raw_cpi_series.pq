let
    Source = PostgreSQL.Database("localhost:5432", "purchasing_power"),
    raw_cpi_series = Source{[Schema="raw",Item="cpi_series"]}[Data]
in
    raw_cpi_series
