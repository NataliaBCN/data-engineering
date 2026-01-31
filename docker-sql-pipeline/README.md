# Docker + SQL Pipeline Homework

This repository contains the solution for the Module 1 homework: **Docker & SQL**.  
The goal is to practice loading NYC Green Taxi data into Postgres using Docker and running SQL queries to answer data questions.

All queries are executed on the database `ny_taxi` in Postgres.

## Environment Setup

- Docker Compose used to launch Postgres and pgAdmin
- Python ingest script downloads data and loads it into Postgres
- Data files:
  - `green_tripdata_2025-11.parquet` (taxi trips)
  - `taxi_zone_lookup.csv` (zone lookup)


## Data Ingest

Run the ingest script:

```bash
docker run --rm \
  --network docker-sql-pipeline_default \
  -v $(pwd):/app \
  -w /app \
  python:3.13 \
  bash -c "pip install -r requirements.txt && python ingest.py --year 2025 --month 11"


or new 
python ingest.py --year 2021 --month 1 --table green_taxi_data --host localhost --user root --password root --port 5432

-- =========================================
-- SQL Queries 
-- =========================================

-- Question 3: Counting short trips (trip_distance <= 1 mile)
SELECT COUNT(*) AS short_trips
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;
-- Answer: 8007

-- Question 4: Longest trip per day (trip_distance < 100 miles)
SELECT DATE(lpep_pickup_datetime) AS pickup_day
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance < 100
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY max_distance DESC
LIMIT 1;
-- Answer: 2025-11-14

-- Question 5: Pickup zone with largest total_amount on 2025-11-18
SELECT z."Zone" AS pickup_zone
FROM green_taxi_data g
JOIN zones z ON g."PULocationID"::bigint = z."LocationID"
WHERE DATE(g."lpep_pickup_datetime") = '2025-11-18'
GROUP BY z."Zone"
ORDER BY SUM(g."total_amount") DESC
LIMIT 1;
-- Answer: "East Harlem North"	

-- Question 6: Drop-off zone with largest single tip for pickups in "East Harlem North"
SELECT z_drop."Zone" AS dropoff_zone
FROM green_taxi_data g
JOIN zones z_pick ON g."PULocationID"::bigint = z_pick."LocationID"
JOIN zones z_drop ON g."DOLocationID"::bigint = z_drop."LocationID"
WHERE z_pick."Zone" = 'East Harlem North'
  AND DATE(g."lpep_pickup_datetime") >= '2025-11-01'
  AND DATE(g."lpep_pickup_datetime") < '2025-12-01'
ORDER BY g."tip_amount" DESC
LIMIT 1;
-- Answer: Yorkville West
