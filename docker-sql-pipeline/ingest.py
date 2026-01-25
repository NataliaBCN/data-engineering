#!/usr/bin/env python
# coding: utf-8

import click
import pandas as pd
from sqlalchemy import create_engine
from tqdm.auto import tqdm
import os
import urllib.request

# Data directory
DATA_DIR = os.path.join(os.getcwd(), "data")
os.makedirs(DATA_DIR, exist_ok=True)

def download_file(url, dest):
    """Download file if it does not exist"""
    if not os.path.exists(dest):
        print(f"Downloading {url} ...")
        urllib.request.urlretrieve(url, dest)
        print(f"Saved to {dest}")
    else:
        print(f"File already exists: {dest}")

@click.command()
@click.option('--user', default='root', help='PostgreSQL user')
@click.option('--password', default='root', help='PostgreSQL password')
@click.option('--host', default='pgdatabase', help='PostgreSQL host')
@click.option('--port', default=5432, type=int, help='PostgreSQL port')
@click.option('--db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--year', type=int, required=True, help='Year of the data')
@click.option('--month', type=int, required=True, help='Month of the data (1-12)')
@click.option('--table', default='green_taxi_data', help='Target table name')
def ingest_data(user, password, host, port, db, year, month, table):
    """Download Green Taxi trips and zones, and load into Postgres"""

    # File names
    trips_file = os.path.join(DATA_DIR, f"green_tripdata_{year}-{month:02d}.parquet")
    zones_file = os.path.join(DATA_DIR, "taxi_zone_lookup.csv")

    # URLs
    trips_url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_{year}-{month:02d}.parquet"
    zones_url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

    # Download files if missing
    download_file(trips_url, trips_file)
    download_file(zones_url, zones_file)

    # Connect to Postgres
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # Load trips data
    print(f"Loading trips from {trips_file} ...")
    df_trips = pd.read_parquet(trips_file)
    df_trips.to_sql(table, engine, if_exists="replace", index=False)
    print(f"Loaded {len(df_trips)} rows into table {table}")

    # Load zones data
    print(f"Loading zones from {zones_file} ...")
    df_zones = pd.read_csv(zones_file)
    df_zones.to_sql("zones", engine, if_exists="replace", index=False)
    print(f"Loaded {len(df_zones)} rows into table zones")

if __name__ == "__main__":
    ingest_data()
