-- Staging Layer
-- Cleans and standardizes taxi trip data

create or replace table `your-gcp-project-id.analytics_dataset.stg_trips` as

select
    pickup_datetime,
    dropoff_datetime,
    passenger_count,
    trip_distance,
    total_amount,
    payment_type,
    extract(year from pickup_datetime) as pickup_year,
    extract(month from pickup_datetime) as pickup_month
from
    `your-gcp-project-id.analytics_dataset.raw_trips`
where
    total_amount > 0
    and trip_distance > 0;
