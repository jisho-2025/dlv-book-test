#!/usr/bin/env bash
set -Eeuo pipefail

: "${DB_URI:?DB_URI is required}"  # ex) postgresql://user:pass@host:5432/db

# 3つの純SQLを1トランザクションで実行（SQLファイル内は純SQLのみ）
tmp_sql="$(mktemp)"
trap 'rm -f "$tmp_sql"' EXIT

{
  echo "BEGIN;"
  cat sql/01_delete_wr_m_sample.sql
  echo
  cat sql/02_insert_new_from_wr.sql
  echo
  cat sql/03_merge_update_from_wr.sql
  echo "COMMIT;"
} > "$tmp_sql"

psql "$DB_URI" -v ON_ERROR_STOP=1 -f "$tmp_sql"
echo "Job1 done."
