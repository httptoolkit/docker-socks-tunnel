# Docker container for MicroSocks
[![Docker Automated build](https://img.shields.io/docker/automated/shawly/microsocks.svg)](https://hub.docker.com/r/shawly/microsocks/) [![Docker Image](https://images.microbadger.com/badges/image/shawly/microsocks.svg)](http://microbadger.com/#/images/shawly/microsocks) [![Build Status](https://travis-ci.org/shawly/docker-microsocks.svg?branch=master)](https://travis-ci.org/shawly/docker-microsocks) [![GitHub Release](https://img.shields.io/github/release/shawly/docker-microsocks.svg)](https://github.com/shawly/docker-microsocks/releases/latest)

This is a Docker container for MicroSocks, a multithreaded, small, efficient SOCKS5 server.

---

[![microsocks](https://dummyimage.com/400x110/ffffff/575757&text=microsocks)](https://github.com/rofl0r/microsocks)

MicroSocks by [rofl0r](https://github.com/rofl0r/microsocks). Binaries built from the latest sources, container based on Alpine.

---
## Table of Content

   * [Docker container for microsocks](#docker-container-for-microsocks)
      * [Table of Content](#table-of-content)
      * [Quick Start](#quick-start)
      * [Usage](#usage)
         * [Environment Variables](#environment-variables)
         * [Ports](#ports)
         * [Changing Parameters of a Running Container](#changing-parameters-of-a-running-container)
      * [Docker Compose File](#docker-compose-file)
      * [Docker Image Update](#docker-image-update)
      * [Support or Contact](#support-or-contact)

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the microsocks docker container with the following command:
```
docker run -d \
    --name=microsocks \
    -p 1080:1080 \
    shawly/microsocks
```

## Usage

```
docker run [-d] \
    --name=microsocks \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    shawly/microsocks
```
| Parameter | Description |
|-----------|-------------|
| -d        | Run the container in background.  If not set, the container runs in foreground. |
| -e        | Pass an environment variable to the container.  See the [Environment Variables](#environment-variables) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host).  See the [Ports](#ports) section for more details. |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`TZ`| [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | `Etc/UTC` |

### Ports

Here is the list of ports used by the container.  They can be mapped to the host
via the `-p` parameter (one per port mapping).  Each mapping is defined in the
following format: `<HOST_PORT>:<CONTAINER_PORT>`.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 1080 | Mandatory | Port used for microsocks. |

### Changing Parameters of a Running Container

As seen, environment variables, volume mappings and port mappings are specified
while creating the container.

The following steps describe the method used to add, remove or update
parameter(s) of an existing container.  The generic idea is to destroy and
re-create the container:

  1. Stop the container (if it is running):
```
docker stop microsocks
```
  2. Remove the container:
```
docker rm microsocks
```
  3. Create/start the container using the `docker run` command, by adjusting
     parameters as needed.

## Docker Compose File

Here is an example of a `docker-compose.yml` file that can be used with
[Docker Compose](https://docs.docker.com/compose/overview/).

Make sure to adjust according to your needs.  Note that only mandatory network
ports are part of the example.

```yaml
version: '3'
services:
  microsocks:
    image: shawly/microsocks
    restart: unless-stopped
    environment:
      - TZ: Europe/Berlin
    ports:
      - "1080:1080"
```

## Docker Image Update

If the system on which the container runs doesn't provide a way to easily update
the Docker image, the following steps can be followed:

  1. Fetch the latest image:
```
docker pull shawly/microsocks
```
  2. Stop the container:
```
docker stop microsocks
```
  3. Remove the container:
```
docker rm microsocks
```
  4. Start the container using the `docker run` command.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

[create a new issue]: https://github.com/shawly/docker-microsocks/issues
