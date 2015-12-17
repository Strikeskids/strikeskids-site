#!/usr/bin/env bash

set -e

ssh strikeskids.com 'cd sk-main && bash scripts/deploy-remote.sh'
