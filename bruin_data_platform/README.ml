# NYC Taxi Data Platform with Bruin (BigQuery)

## Overview

This project implements a production-style ELT pipeline using Bruin and Google BigQuery.

Architecture:
- Ingestion layer (Python + Seed)
- Staging layer (SQL + deduplication + incremental)
- Reports layer (aggregations + quality checks)

## Stack

- Bruin CLI
- Google BigQuery
- Python (pandas, pyarrow)
- Incremental strategy: time_interval
- 24 built-in quality checks

## Run Locally

```bash
bruin validate ./pipeline/pipeline.yml

bruin run ./pipeline/pipeline.yml \
  --full-refresh \
  --start-date 2022-01-01 \
  --end-date 2022-02-01 \
  --var 'taxi_types=["yellow"]'


## Notes

- Developed locally with Bruin CLI
- Used BigQuery as warehouse backend
- Tested with 2-month sample before full backfill
- Used time_interval strategy for incremental processing
