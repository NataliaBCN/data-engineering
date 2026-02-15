{{ config(materialized='view') }}

select
    dispatching_base_num,
    pickup_datetime as pickup_datetime,
    dropoff_datetime as dropoff_datetime,
    passenger_count,
    trip_distance,
    pulocationid as pickup_location_id,
    dolocationid as dropoff_location_id,
    fare_amount
from {{ source('raw', 'fhv_tripdata') }}
where dispatching_base_num is not null
