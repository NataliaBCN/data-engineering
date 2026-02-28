-- Ingestion Layer
-- Loads raw taxi trips data into BigQuery

create or replace table `your-gcp-project-id.analytics_dataset.raw_trips` as

select
    *
from
    `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;
