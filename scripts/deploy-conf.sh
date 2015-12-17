#!/usr/bin/env bash

set -e
set -x

scp conf/nginx.conf strikeskids.com:/etc/nginx/sites-enabled/main.conf
ssh strikeskids.com 'nginx -s reload'
