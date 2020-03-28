#
# microsocks Dockerfile
#
# https://github.com/shawly/docker-microsocks
#

# Set alpine version
ARG ALPINE_VERSION=3.11

# Set vars for s6 overlay
ARG S6_OVERLAY_VERSION=v1.22.1.0
ARG S6_OVERLAY_ARCH=amd64
ARG S6_OVERLAY_RELEASE=https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz

# Set microsocks vars
ARG MICROSOCKS_REPO=https://github.com/rofl0r/microsocks
ARG MICROSOCKS_BRANCH=v1.0.1
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

ARG S6_OVERLAY_RELEASE

ENV S6_OVERLAY_RELEASE=${S6_OVERLAY_RELEASE}

# Download S6 Overlay
ADD ${S6_OVERLAY_RELEASE} /tmp/s6overlay.tar.gz

# Copy binary from build container.
COPY --from=builder /tmp/microsocks-bin/microsocks /usr/local/bin/microsocks

# Install runtime deps and add users.
RUN \
  echo "Installing runtime dependencies..." && \
  apk add --no-cache \
    coreutils \
    shadow \
    tzdata \
    curl && \
  echo "Extracting s6 overlay..." && \
    tar xzf /tmp/s6overlay.tar.gz -C / && \
  echo "Creating microsocks user..." && \
    useradd -u 1000 -U -M -s /bin/false microsocks && \
    usermod -G users microsocks && \
    mkdir -p /var/log/microsocks && \
    chown -R nobody:nogroup /var/log/microsocks && \
  echo "Cleaning up temp directory..." && \
    rm -rf /tmp/*

# Add files.
ADD rootfs/ /

# Expose ports.
EXPOSE 1080

# Healthcheck
HEALTHCHECK --interval=5m --timeout=10s \
  CMD curl -f -L -x socks5h://localhost:1080 'https://api.ipify.org' || exit 1

# Metadata.
LABEL \
      org.label-schema.name="MicroSocks" \
      org.label-schema.description="Docker container for MicroSocks" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/shawly/docker-microsocks" \
      org.label-schema.schema-version="1.0"

# Start s6.
ENTRYPOINT ["/init"]
