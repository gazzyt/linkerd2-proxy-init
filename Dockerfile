## compile proxy-init utility
FROM golang:1.12.9 as golang
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -o /out/linkerd2-proxy-init -mod=readonly -ldflags "-s -w" -v

## package runtime
FROM arm32v7/debian:stretch-20190812-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        iptables \
    && rm -rf /var/lib/apt/lists/*
COPY LICENSE /linkerd/LICENSE
COPY --from=golang /out/linkerd2-proxy-init /usr/local/bin/proxy-init
ENTRYPOINT ["/usr/local/bin/proxy-init"]
