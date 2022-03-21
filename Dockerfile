ARG ENVIRONMENT=develop
FROM golang:alpine AS goBuilder

RUN echo "Downloading software" && \
    apk add --no-cache git openssh alpine-sdk gcc-go && \
    echo "Downloading mage..." && \
    git clone https://github.com/magefile/mage && \
    cd mage && \
    echo "Building and installing mage..." && \
    go run bootstrap.go && \
    echo "Installing golint" && \
    go get -u golang.org/x/lint/golint

COPY . /go/src/github.com/chaos-hip/partmate
WORKDIR /go/src/github.com/chaos-hip/partmate
RUN go build

FROM node:latest AS nodeBuilder
COPY ./ui /src
WORKDIR /src
RUN export NODE_OPTIONS=--openssl-legacy-provider && \
    npm ci && \
    npm run build

# The real image
FROM alpine
WORKDIR /opt/app/
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/partmate .
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/dbmigrations/ ./dbmigrations/
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/templates/ ./templates/
COPY --from=nodeBuilder /src/dist/ ./public/
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
CMD ["./partmate"]
