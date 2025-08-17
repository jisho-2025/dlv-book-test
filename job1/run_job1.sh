#!/bin/bash
set -e

echo "Deleting wr_m_sample..."
psql "$DATABASE_URL" -f /app/sql/delete_wr_m_sample.sql

echo "Downloading m_sample.csv from Cloud Storage..."
gsutil cp gs://$GCS_BUCKET/m_sample.csv /tmp/m_sample.csv

echo "Loading CSV into wr_m_sample..."
psql "$DATABASE_URL" -c "\COPY wr_m_sample FROM '/tmp/m_sample.csv' WITH (FORMAT csv, HEADER true)"
