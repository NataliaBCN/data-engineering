-- Reporting Layer
-- Aggregates monthly revenue by service type

create or replace table `your-gcp-project-id.analytics_dataset.mart_monthly_revenue` as

select
    pickup_year,
    pickup_month,
    sum(total_amount) as monthly_revenue,
    count(*) as total_trips
from
    `your-gcp-project-id.analytics_dataset.stg_trips`
group by
    pickup_year,
    pickup_month
order by
    pickup_year,
    pickup_month;
