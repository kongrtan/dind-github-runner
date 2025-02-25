#FROM ubuntu:22.04
FROM mcr.microsoft.com/dotnet/sdk:8.0.302-jammy

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    iptables \
    ca-certificates \
    curl \
    iproute2 \
    iputils-ping \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Docker 바이너리 추가
COPY docker.tgz /tmp/docker.tgz
RUN tar -xzf /tmp/docker.tgz -C /usr/local/bin --strip-components=1 \
    && rm /tmp/docker.tgz

# Containerd 및 runc 추가
COPY containerd.tar.gz /tmp/containerd.tar.gz
COPY runc /usr/local/bin/runc
RUN tar -xzf /tmp/containerd.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/runc \
    && rm /tmp/containerd.tar.gz

# CNI 플러그인 추가
COPY cni-plugins.tgz /tmp/cni-plugins.tgz
RUN mkdir -p /opt/cni/bin && tar -xzf /tmp/cni-plugins.tgz -C /opt/cni/bin \
    && rm /tmp/cni-plugins.tgz


# 🏃 GitHub Actions Runner 설치
WORKDIR /actions-runner
COPY actions-runner.tar.gz /tmp/actions-runner.tar.gz
RUN tar xzf /tmp/actions-runner.tar.gz -C /actions-runner && rm /tmp/actions-runner.tar.gz

# GitHub Actions Runner 실행 스크립트 추가
COPY start-runner.sh /actions-runner/start-runner.sh
RUN chmod +x /actions-runner/start-runner.sh


# Entrypoint 스크립트 추가
COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Docker 실행 스크립트 설정
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
#CMD ["dockerd", "--host=unix:///var/run/docker.sock"]
CMD ["/actions-runner/start-runner.sh"]
