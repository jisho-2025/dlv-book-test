FROM postgres:15
WORKDIR /app
COPY run_job2.sh /app/
COPY sql /app/sql
ENTRYPOINT ["bash", "/app/run_job2.sh"]
