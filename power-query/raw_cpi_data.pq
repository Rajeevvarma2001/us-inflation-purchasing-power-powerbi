let
    Source = PostgreSQL.Database("localhost:5432", "purchasing_power"),
    raw_cpi_data = Source{[Schema="raw",Item="cpi_data"]}[Data]
in
    raw_cpi_data
