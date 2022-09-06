# DreamHost runs on 18.04
FROM ubuntu:18.04-20220829@sha256:ee1b6a6b513d6db9a14cf6e6d37895a7c70008d313d08cdf66e07cf617a3b978

ADD go1.19.1.linux-amd64.tar.gz /
ENV PATH="$PATH:/go/bin"
ENV GOROOT="/go"
WORKDIR /app