FROM conda/miniconda3:latest
LABEL maintainer="Guido Schmutz <guido.schmutz@trivadis.com>"

WORKDIR /mlflow/

ARG MLFLOW_VERSION=1.20.1
RUN mkdir -p /mlflow/ \
  && apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    default-libmysqlclient-dev \
    libpq-dev \
  && pip install \
    mlflow==$MLFLOW_VERSION \
    sqlalchemy \
    boto3 \
    google-cloud-storage \
    psycopg2 \
    mysqlclient

EXPOSE 5000

ENV BACKEND_URI /mlflow/store
ENV ARTIFACT_ROOT /mlflow/mlflow-artifacts
CMD echo "Artifact Root is ${ARTIFACT_ROOT}" && \
  mlflow server \
  --backend-store-uri ${BACKEND_URI} \
  --default-artifact-root ${ARTIFACT_ROOT} \
  --port ${PORT} \
  --host 0.0.0.0