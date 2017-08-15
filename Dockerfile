# Dockerfile
FROM datadog/docker-dd-agent

ADD postgres.yaml /etc/dd-agent/conf.d/

ENV DD_APM_ENABLED=true \
    DD_LOGS_STDOUT=yes

#Disable Docker Daemon checks, not allowed on Aptible
RUN rm /etc/dd-agent/conf.d/docker_daemon.yaml
