#!/bin/bash

if [[ $API_KEY ]]; then
	sed -i -e "s/^.*api_key:.*$/api_key: ${API_KEY}/" /etc/dd-agent/datadog.conf
else
	echo "You must set API_KEY environment variable to run the Datadog Agent container"
	exit 1
fi


if [[ $LOGS_STDOUT == "yes" ]]; then
  sed -i -e "/^.*_logfile.*$/d" /etc/dd-agent/supervisor.conf
  sed -i -e "/^.*\[program:.*\].*$/a stdout_logfile=\/dev\/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=\/dev\/stderr\nstderr_logfile_maxbytes=0" /etc/dd-agent/supervisor.conf
fi

# TODO:
#	get config from AWS

exec "$@"
