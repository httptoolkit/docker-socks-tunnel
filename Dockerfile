#
# microsocks Dockerfile
#
# https://github.com/httptoolkit/docker-socks-tunnel
#

# Set alpine version
ARG ALPINE_VERSION=3.11

# Set microsocks vars
ARG MICROSOCKS_REPO=https://github.com/rofl0r/microsocks
ARG MICROSOCKS_BRANCH=v1.0.2
ARG MICROSOCKS_URL=${MICROSOCKS_REPO}/archive/${MICROSOCKS_BRANCH}.tar.gz

# Build microsocks
FROM alpine:${ALPINE_VERSION} as builder

ARG MICROSOCKS_REPO
ARG MICROSOCKS_BRANCH
ARG MICROSOCKS_URL

ENV MICROSOCKS_REPO=${MICROSOCKS_REPO} \
    MICROSOCKS_BRANCH=${MICROSOCKS_BRANCH} \
    MICROSOCKS_URL=${MICROSOCKS_URL}

# Change working dir.
WORKDIR /tmp

# Add MICROSOCKS repo archive
ADD ${MICROSOCKS_URL} /tmp/microsocks.tar.gz

# Install deps and build binary.
RUN \
  echo "Installing build dependencies..." && \
  apk add --update --no-cache \
    git \
    build-base \
    tar && \
  echo "Building MicroSocks..." && \
    tar -xvf microsocks.tar.gz --strip 1 && \
    make && \
    chmod +x /tmp/microsocks && \
    mkdir -p /tmp/microsocks-bin && \
    cp -v /tmp/microsocks /tmp/microsocks-bin

# Runtime container
FROM alpine:${ALPINE_VERSION}

# Copy binary from build container.
COPY --from=builder /tmp/microsocks-bin/microsocks /usr/local/bin/microsocks

# Install runtime deps and add users.
RUN \
  echo "Installing runtime dependencies..." && \
  apk add --no-cache \
    shadow && \
  echo "Creating microsocks user..." && \
    useradd -u 1000 -U -M -s /bin/false microsocks && \
    usermod -G users microsocks && \
    mkdir -p /var/log/microsocks && \
    chown -R nobody:nogroup /var/log/microsocks && \
  apk del shadow && \
  echo "Cleaning up temp directory..." && \
    rm -rf /tmp/*

EXPOSE 1080

USER microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
