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
FROM alpine:${ALPINE_VERSION} as BIN_BUILDER

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

# Runtime environment builder
FROM alpine:${ALPINE_VERSION} as RUNTIME_BUILDER

# Copy binary from build container.
COPY --from=BIN_BUILDER /tmp/microsocks-bin/microsocks /usr/local/bin/microsocks

# Install runtime deps and create users.
RUN \
  echo "Installing runtime dependencies..." && \
  apk add --no-cache \
    shadow && \
  echo "Creating microsocks user..." && \
    useradd -u 1000 -U -M -s /bin/false microsocks && \
    usermod -G users microsocks && \
    mkdir -p /var/log/microsocks && \
    chown -R nobody:nogroup /var/log/microsocks && \
  echo "Remove APK & shadow" && \
    apk del shadow apk-tools && \
  echo "Cleaning up temp directory..." && \
    rm -rf /tmp/*

# Copy the files from the above into a new from-scratch image, to lose the history left
# in the base Alpine image, and pull us down to <2MB
FROM scratch

COPY --from=RUNTIME_BUILDER / /

EXPOSE 1080

USER microsocks

ENTRYPOINT ["/usr/local/bin/microsocks"]
