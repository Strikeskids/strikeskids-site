#!/usr/bin/env bash

set -x -e

git pull
JEKYLL_ENV=production jekyll build --destination /www/strikeskids
