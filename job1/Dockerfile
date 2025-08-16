FROM debian:stable-slim

# psql と gsutil を入れる
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client ca-certificates curl gnupg lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/google-cloud-archive-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/google-cloud-archive-keyring.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
      > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y --no-install-recommends google-cloud-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY sql/ /app/sql/
COPY csv_importer.sh /app/csv_importer.sh
RUN chmod +x /app/csv_importer.sh

CMD ["/app/csv_importer.sh"]
