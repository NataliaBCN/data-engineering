# NYC Taxi Analytics Engineering Project (dbt + BigQuery)

## Objective

Build a modern analytics pipeline using dbt to transform NYC Taxi parquet data
into a business-ready data mart for monthly revenue analysis by:

- Pickup Zone
- Service Type (Green / Yellow)
- Month

---

# Architecture

GCS Parquet Files  
→ BigQuery External Tables  
→ Staging Models  
→ Intermediate (Union)  
→ Fact Table (fct_trips)  
→ Data Mart (mart_monthly_zone_revenue)


Question 1. Q1: dbt run --select int_trips_unioned builds which models? (1 point)

int_trips_unioned only

Question 2. Q2: New value 6 appears in payment_type. What happens on dbt test? (1 point)

dbt fails the test with non-zero exit code

Question 3. Q3: Count of records in fct_monthly_zone_revenue? (1 point)


SELECT COUNT(*) FROM nytaxi_prod.fct_monthly_zone_revenue

12,998

Question 4. Q4: Zone with highest revenue for Green taxis in 2020? (1 point)

select pickup_zone, sum(revenue_monthly_total_amount) as total_revenue
from nytaxi_prod.fct_monthly_zone_revenue
where service_type='Green' and extract(year from revenue_month) = 2020
group by pickup_zone
order by total_revenue desc
limit 1

East Harlem North

Question 5. Q5: Total trips for Green taxis in October 2019? (1 point)

select sum(total_monthly_trips)
from nytaxi_prod.fct_monthly_zone_revenue
where service_type='Green' 
  and revenue_month = '2019-10-01'

384,624

Question 6. Q6: Count of records in stg_fhv_tripdata (filter dispatching_base_num IS NULL)? (1 point)

select count(*)
from nytaxi_prod.stg_fhv_tripdata

43,244,693

