FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

# psql を入れる
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY run.sh /workspace/run.sh
COPY jobs/ /workspace/jobs/
RUN chmod +x /workspace/run.sh

# デフォルトは job1 を実行。Cloud Run Job 側で --args で job2 などに切替
ENTRYPOINT ["/bin/bash","-lc","/workspace/run.sh"]
CMD ["job1"]
