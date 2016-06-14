# VERSION 1.7.0
# AUTHOR: Adam Gutcheon
# DESCRIPTION: Basic Airflow container
# SOURCE: https://github.com/voyager-data/docker-airflow
# FORKED from https://github.com/camilb/docker-airflow

FROM ubuntu:trusty
MAINTAINER Adam Gutcheon

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV AIRFLOW_VERSION 1.7.1
ENV AIRFLOW_HOME /usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.utf8
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV LC_CTYPE en_US.utf8
ENV LC_MESSAGES en_US.utf8
ENV LC_ALL  en_US.utf8

RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
    apt-utils\
    netcat \
    curl \
    python-pip \
    python-dev \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    build-essential \
    && locale-gen en_US.utf8 \
    && update-locale LANG=en_US.utf8 LC_ALL=en_US.utf8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && pip install airflow==${AIRFLOW_VERSION} \
    && pip install airflow[celery]==${AIRFLOW_VERSION} \
    && pip install airflow[hdfs]==${AIRFLOW_VERSION} \
    && pip install airflow[postgres]==${AIRFLOW_VERSION} \
    && pip install airflow[rabbitmq]==${AIRFLOW_VERSION} \
    && pip install airflow[s3]==${AIRFLOW_VERSION} \
    && pip install airflow[slack]==${AIRFLOW_VERSION} \
    && apt-get remove --purge -yqq build-essential python-pip python-dev libpq-dev libffi-dev libssl-dev \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

ADD entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
ADD hosts /etc/hosts

RUN \
    chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
