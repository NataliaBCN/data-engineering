
---

## **Orchestration/README.md**

# Kestra Flows for Module 2

This folder contains **Kestra flows** for processing NYC taxi datasets (yellow and green taxis).

### Files

- `05_postgres_taxi_scheduled.yaml` – main flow that:
  1. Downloads CSV files from the official NYC TLC dataset.
  2. Creates staging and main tables in PostgreSQL.
  3. Merges data while generating unique row IDs.
  4. Purges temporary CSV files to save space.

---

### How to Run

1. Make sure Docker services are running (see Docker-SQL folder).
2. Open **Kestra UI** on port 8080.
3. Select the flow for **Yellow Taxi** or **Green Taxi**.
4. Trigger the flow:
   - Use **Backfill** to cover 2021 (Jan–Jul)  
   - Or manually trigger each month
5. Once execution finishes, data is merged into PostgreSQL tables.

---

### Notes

- Variables like `{{inputs.taxi}}` and `{{trigger.date}}` are used to dynamically download and process files.
- The `purge_files` task is used to remove downloaded CSVs after execution.
- The flow is fully compatible with both yellow and green taxi datasets.

