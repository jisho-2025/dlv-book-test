# gsutil が使えるベース
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

# psql クライアントを入れる
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-client \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
# あなたのスクリプトとSQLをコピー（パスはリポジトリに合わせて調整）
COPY job1.sh /workspace/job1.sh
COPY sql/ /workspace/sql/

# 実行権限
RUN chmod +x /workspace/job1.sh

# ジョブは「実行して終わる」形式
ENTRYPOINT ["/bin/bash","-lc","/workspace/job1.sh"]
