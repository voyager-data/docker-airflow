# VERSION 1.0
# AUTHOR: Camil Blanaru
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t camil/airflow
# SOURCE: https://github.com/camilb/airflow

FROM python:2.7
MAINTAINER Camil Blanaru

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ENV AIRFLOW_HOME /usr/local/airflow

# Add airflow user
RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
    netcat \
    curl \
    libmysqlclient-dev \
    libkrb5-dev \
    libsasl2-dev \
    libssl-dev \
    libffi-dev \
    build-essential \
    && pip install airflow \
    && pip install airflow[crypto] \
    && pip install airflow[celery] \
    && pip install airflow[mysql] \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

ADD script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN \
    chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
