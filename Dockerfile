# Dockerfile
FROM quay.io/aptible/ubuntu:14.04

RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && rm -rf /var/lib/apt/lists/*

RUN sh -c "echo 'deb https://apt.datadoghq.com/ stable main' > /etc/apt/sources.list.d/datadog.list"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52

RUN apt-get update && apt-get install -y datadog-agent

ADD rabbitmq.yaml /etc/dd-agent/conf.d/

RUN sh -c "sed 's/api_key:.*/api_key: YOURAPIKEY/' /etc/dd-agent/datadog.conf.example > /etc/dd-agent/datadog.conf"
RUN sh -c "sed -i 's/# apm_enabled: false/apm_enabled: true/' /etc/dd-agent/datadog.conf"

EXPOSE 8126
