# Dockerfile
FROM aptible/ubuntu:14.04

# Install Datadog
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && rm -rf /var/lib/apt/lists/*
RUN sh -c "echo 'deb https://apt.datadoghq.com/ stable 6' > /etc/apt/sources.list.d/datadog.list"
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 382E94DE
RUN apt-get update && apt-get install -y datadog-agent

# Create the primary Datadog config file
RUN cp /etc/datadog-agent/datadog.yaml.example /etc/datadog-agent/datadog.yaml

# Add a custom MongoDB monitoring script 
ADD mongo.yaml etc/datadog-agent/conf.d/mongo.d/conf.yaml

# Update the Datadog API key in the primary config file
ADD .aptible.env /
RUN set -a  && . /.aptible.env && /bin/sed -i "s/api_key:.*/api_key: $DD_API_KEY/" /etc/datadog-agent/datadog.yaml

# Make that the Datadog agent run on startup
CMD ["datadog-agent", "start"]