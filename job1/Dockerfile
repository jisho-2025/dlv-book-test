FROM gcr.io/cloudsql-docker/gce-proxy:1.33.7 as cloud_sql_proxy

FROM postgres:15

RUN apt-get update && apt-get install -y curl gnupg lsb-release \
    && apt-get install -y google-cloud-sdk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY run_job1.sh /app/
COPY sql /app/sql

ENTRYPOINT ["bash", "/app/run_job1.sh"]
