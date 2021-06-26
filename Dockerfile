ARG ENVIRONMENT=develop
FROM golang:alpine AS builder

ENV GOPRIVATE="git.chaos-hip.de"

RUN echo "Downloading software" && \
    apk add --no-cache git openssh alpine-sdk gcc-go && \
    echo "Downloading mage..." && \
    git clone https://github.com/magefile/mage && \
    cd mage && \
    echo "Building and installing mage..." && \
    go run bootstrap.go && \
    echo "Installing golint" && \
    go get -u golang.org/x/lint/golint

COPY . /go/src/git.chaos-hip.de/RepairCafe/PartMATE
WORKDIR /go/src/git.chaos-hip.de/RepairCafe/PartMATE
RUN go build

# The real image
FROM alpine
WORKDIR /opt/app/
COPY --from=builder /go/src/git.chaos-hip.de/RepairCafe/PartMATE/PartMATE .
COPY --from=builder /go/src/git.chaos-hip.de/RepairCafe/PartMATE/dbmigrations/ ./dbmigrations/
COPY --from=builder /go/src/git.chaos-hip.de/RepairCafe/PartMATE/templates/ ./templates/
RUN echo "Creating application user" && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "10001" \
    "appuser" && \
    echo "Creating directories" && \
    mkdir -p /opt/app/data && \
    chown appuser:appuser /opt/app/data
USER appuser:appuser
CMD ["./PartMATE"]