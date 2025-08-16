#!/usr/bin/env bash
set -Eeuo pipefail

JOB="${1:-job1}"                          # 引数で job 名を受け取る。未指定なら job1
: "${DB_URI:?DB_URI is required}"         # 例: postgresql://user:pass@host:5432/db

SQL_DIR="/workspace/jobs/${JOB}/sql"
if [ ! -d "$SQL_DIR" ]; then
  echo "SQL dir not found: $SQL_DIR" >&2
  exit 2
fi

# BEGIN; ... (全*.sqlを順番に) ... COMMIT; を一時ファイルに束ねて1トランザクションで実行
TMP_SQL="$(mktemp)"
trap 'rm -f "$TMP_SQL"' EXIT

{
  echo "BEGIN;"
  # 数字順に並べて結合（純SQLのみ）
  # shellcheck disable=SC2045
  for f in $(ls -1 "$SQL_DIR"/*.sql | sort); do
    cat "$f"
    echo
  done
  echo "COMMIT;"
} > "$TMP_SQL"

psql "$DB_URI" -v ON_ERROR_STOP=1 -f "$TMP_SQL"
echo "[${JOB}] done."
