#!/usr/bin/env bash
set -Eeuo pipefail

JOB="${1:-job1}"                          # 引数で job 名を受け取る。未指定なら job1

: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${CLOUDSQL_CONNECTION_NAME:?CLOUDSQL_CONNECTION_NAME is required}"

# Cloud SQL Auth Proxy 経由の接続用 URI を組み立てる
DB_URI="postgresql://${DB_USER}:${DB_PASSWORD}@/${DB_NAME}?host=/cloudsql/${CLOUDSQL_CONNECTION_NAME}"

echo "=== Starting job ${JOB} with DB_URI ==="
echo "${DB_URI}"

SQL_DIR="/workspace/jobs/${JOB}/sql"
if [ ! -d "$SQL_DIR" ]; then
  echo "SQL dir not found: $SQL_DIR" >&2
  exit 2
fi

# BEGIN; ... COMMIT; でラップして1トランザクションで実行
TMP_SQL="$(mktemp)"
trap 'rm -f "$TMP_SQL"' EXIT

{
  echo "BEGIN;"
  for f in $(ls -1 "$SQL_DIR"/*.sql | sort); do
    cat "$f"
    echo
  done
  echo "COMMIT;"
} > "$TMP_SQL"

psql "$DB_URI" -v ON_ERROR_STOP=1 -f "$TMP_SQL"
echo "[${JOB}] done."
