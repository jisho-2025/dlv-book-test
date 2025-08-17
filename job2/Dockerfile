# gsutil が入っている Google 提供イメージ
FROM google/cloud-sdk:slim

# PostgreSQL クライアントを追加
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ
WORKDIR /app

# シェルスクリプトと SQL をコピー
COPY run_job2.sh /app/
COPY sql /app/sql

# デフォルト実行コマンド
ENTRYPOINT ["bash", "/app/run_job2.sh"]
