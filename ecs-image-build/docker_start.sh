#!/bin/bash
#
# Start script for presenter-account-consumer
PORT=3000

exec java -jar -Dserver.port="${PORT}" "presenter-account-consumer.jar"