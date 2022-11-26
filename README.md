# Docker GraalVM builder images

## 1. Quick start

- Show gu plugins

```bash
# Testing graalvm plugins
docker run --rm --entrypoint /graalvm-ce/bin/gu wl4g/graalvm-ce:22.3.0-java17 list
```

- Build native image example

```bash

```

## 2. Development Guide

```bash
./build.sh build
./build.sh push
```
