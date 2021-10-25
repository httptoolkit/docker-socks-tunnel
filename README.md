# Docker SOCKS Tunnel

> _Part of [HTTP Toolkit](https://httptoolkit.tech): powerful tools for building, testing & debugging HTTP(S)_

This is a minimal Docker container for MicroSocks, a multithreaded, small, efficient SOCKS5 server.

This is intended to be used internally by HTTP Toolkit, to tunnel traffic into Docker networks, especially in environments (Windows & Mac) where host to container connectivity is not usually available.

The container itself uses [Microsocks](https://github.com/rofl0r/microsocks) to provide a small & lightweight SOCKS5 proxy, and is designed to be as small as reasonably possible on top of that base: currently 5.7MB on disk, or approx 2.5MB when compressed for download.

To run this:

```
docker run -d --name=httptoolkit-docker-tunnel -p 127.0.0.1:1080:1080 httptoolkit/docker-socks-tunnel
```

This will connect port 1080 on the host to the SOCKS5 proxy in the container. Traffic can be proxied through this port to reach any container on the same network as the tunnel container.

SOCKS5H must be used, resolving domain names within the tunnel, not beforehand, unless you have a DNS configuration that can resolve Docker container names externally.

This repo is a fork of the now-archived & officially abandoned [docker-microsocks](https://github.com/shawly/docker-microsocks) repo, modified & distributed under the MIT license.