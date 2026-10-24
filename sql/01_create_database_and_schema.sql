-- Run as a superuser (e.g. postgres) in psql:
--   psql -U postgres -f sql/01_create_database_and_schema.sql

CREATE DATABASE purchasing_power;

\connect purchasing_power

-- Staging area: BLS files land here unchanged.
CREATE SCHEMA IF NOT EXISTS raw;
