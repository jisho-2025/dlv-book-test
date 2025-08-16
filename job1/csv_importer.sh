#!/usr/bin/env bash
set -euo pipefail

# 必須環境変数
: "${INSTANCE_CONNECTION_NAME:?}"
: "${DB_NAME:?}"
: "${DB_USER:?}"
: "${DB_PASSWORD:?}"
: "${GCS_BUCKET:?}"     # 例: dlv-book-bucket-test

# Cloud SQL への Unix ソケット接続URI
PSQL_URI="postgresql://${DB_USER}:${DB_PASSWORD}@/${DB_NAME}?host=/cloudsql/${INSTANCE_CONNECTION_NAME}&sslmode=disable"

WORK=/tmp/m_sample_work
CSV_LOCAL="${WORK}/m_sample.csv"
mkdir -p "$WORK"

echo "== (1) Download CSV from gs://${GCS_BUCKET}/m_sample.csv =="
gsutil cp "gs://${GCS_BUCKET}/m_sample.csv" "$CSV_LOCAL"

echo "== (2) Create table if not exists =="
psql "$PSQL_URI" -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE IF NOT EXISTS m_sample (
  id INTEGER,
  name VARCHAR(255),
  value INTEGER
);
SQL

echo "== (3) Import CSV into m_sample =="
# 既存データを残す/置換のポリシーは運用に合わせて調整（必要なら TRUNCATE）
# psql "$PSQL_URI" -v ON_ERROR_STOP=1 -c "TRUNCATE TABLE m_sample;"
psql "$PSQL_URI" -v ON_ERROR_STOP=1 -c "\copy m_sample (id,name,value) FROM '${CSV_LOCAL}' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')"

echo "== (4) Select 1 row from m_sample =="
# 見やすいようにCSV形式で1行だけ出す
psql "$PSQL_URI" -v ON_ERROR_STOP=1 -t -A -F, -f /app/sql/select_m_sample.sql
