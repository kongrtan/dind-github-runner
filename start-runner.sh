#!/bin/bash
set -e

# GitHub Actions Runner 등록
echo "➡ Registering GitHub Actions Runner..."
./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO \
            --token YOUR_GITHUB_RUNNER_TOKEN \
            --unattended \
            --replace

# Docker Daemon 실행
dockerd &

# GitHub Actions Runner 실행
echo "➡ Starting runner..."
./run.sh
