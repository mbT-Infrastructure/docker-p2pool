#!/usr/bin/env bash
set -e -o pipefail

ln --force --symbolic /dev/null p2pool.log

exec "$@"
