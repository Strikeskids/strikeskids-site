#!/usr/bin/env bash

set -e
set -x

scp conf/nginx.conf strikeskids.com:/etc/nginx/sites-available/main
ssh strikeskids.com 'nginx -s reload'
