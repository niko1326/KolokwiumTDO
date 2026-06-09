#!/bin/sh
set -e

# Ensure the SQLite volume is writable by the app user.
chown -R app:app /data

exec gosu app "$@"
