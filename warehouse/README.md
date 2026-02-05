# Module 3 Homework – BigQuery & Data Warehousing

## Dataset
Yellow Taxi Trip Records (Jan–Jun 2024)

**Create an external table using the Yellow Taxi Trip Records.**

CREATE SCHEMA IF NOT EXISTS `arctic-thought-459809-d1.taxi`
  OPTIONS (location = 'US');

CREATE OR REPLACE EXTERNAL TABLE `arctic-thought-459809-d1.taxi.external_yellow_taxi_2024`
  OPTIONS (
    format = 'PARQUET',
    uris = ['gs://yellow-taxi-2024-tridata/yellow_tripdata_2024-*.parquet']);

**Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table).**
CREATE OR REPLACE TABLE `arctic-thought-459809-d1.taxi.yellow_taxi_2024`
AS
SELECT *
FROM `arctic-thought-459809-d1.taxi.external_yellow_taxi_2024`;

**Question 1. Counting records**
What is count of records for the 2024 Yellow Taxi Data?
***Answer***
20332093

select count(1)
from `taxi.yellow_taxi_2024`

**Question 2. Data read estimation**
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

***Answer***
0 MB for the External Table and 155.12 MB for the Materialized Table

select count(distinct PULocationID)
from `taxi.yellow_taxi_2024`

select count(distinct PULocationID)
from `taxi.external_yellow_taxi_2024`

**Question 3. Understanding columnar storage**
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.
Why are the estimated number of Bytes different?

***Answer***
BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

select PULocationID
from `taxi.external_yellow_taxi_2024`;

select PULocationID, DOLocationID
from `taxi.yellow_taxi_2024`

**Question 4. Counting zero fare trips**
How many records have a fare_amount of 0?

***Answer***
8,333

SELECT COUNT(*)
FROM `taxi.yellow_taxi_2024`
WHERE fare_amount = 0;

**Question 5. Partitioning and clustering**
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

***Answer***
Partition by tpep_dropoff_datetime and Cluster on VendorID
CREATE OR REPLACE TABLE `arctic-thought-459809-d1.taxi.yellow_taxi_2024_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `arctic-thought-459809-d1.taxi.yellow_taxi_2024`;

**Question 6. Partition benefits**
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

***Answer***
310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

SELECT DISTINCT VendorID
FROM `taxi.yellow_taxi_2024`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT VendorID
FROM `taxi.yellow_taxi_2024_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

**Question 7. External table storage**
Where is the data stored in the External Table you created?

***Answer***
GCP Bucket


**Question 8. Clustering best practices**
It is best practice in Big Query to always cluster your data:

***Answer***
False

**Question 9. Understanding table scans**
No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

***Answer***

SELECT DISTINCT VendorID
FROM `taxi.yellow_taxi_2024_partitioned`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';