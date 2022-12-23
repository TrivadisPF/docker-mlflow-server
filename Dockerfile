FROM python:3.8
LABEL maintainer="Guido Schmutz <guido.schmutz@trivadis.com>"

WORKDIR /mlflow/

ARG MLFLOW_VERSION=2.1.0
ARG PORT=5000

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
  --gunicorn-opts "--log-level debug" \
  --port ${PORT} \
  --host 0.0.0.0
