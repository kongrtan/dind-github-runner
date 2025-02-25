#!/bin/sh
set -e

# Docker Daemon 실행
echo "➡ Starting Docker Daemon..."
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &

exec "$@"
#!/bin/sh
set -e

# Docker Daemon 실행
echo "➡ Starting Docker Daemon..."
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &

exec "$@"
