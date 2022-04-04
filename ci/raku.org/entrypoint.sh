#!/usr/bin/env bash
set -ex
sh update-docker.sh
service cron start
exec "$@"