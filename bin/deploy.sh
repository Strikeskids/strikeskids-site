#!/usr/bin/env bash

set -e
set -x

JEKYLL_ENV=production jekyll build
rsync --delete -r _site/ strikeskids.com:/www/strikeskids/jekyll/
