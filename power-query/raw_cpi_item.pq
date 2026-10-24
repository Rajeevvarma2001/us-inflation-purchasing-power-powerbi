let
    Source = PostgreSQL.Database("localhost:5432", "purchasing_power"),
    raw_cpi_item = Source{[Schema="raw",Item="cpi_item"]}[Data]
in
    raw_cpi_item
