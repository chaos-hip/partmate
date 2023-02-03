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

# The real image
FROM alpine
COPY ./ui/dist /opt/app/public
WORKDIR /opt/app/
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/partmate .
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/dbmigrations/ ./dbmigrations/
COPY --from=goBuilder /go/src/github.com/chaos-hip/partmate/templates/ ./templates/
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
