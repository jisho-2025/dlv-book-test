#!/bin/bash
set -e

echo "Merging wr_m_sample into m_sample..."
psql "$DATABASE_URL" -f /app/sql/merge_m_sample.sql
