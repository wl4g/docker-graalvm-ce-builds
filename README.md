# Docker GraalVM builder images

## 1. Quick start

- Show plugins

```bash
docker run --rm wl4g/graalvm-ce:22.3.0-java17 /graalvm-ce/bin/gu list
```

- Build with Maven example

```bash
d run --rm \
-v $M2_HOME:/maven \
-v $HOME/.m2/:/root/.m2 \
-v $PWD/demo:/workspace \
registry.cn-shenzhen.aliyuncs.com/wl4g/graalvm-ce:22.3.0-java17 \
/maven/bin/mvn -U -T 2C clean package -DskipTests -Dmaven.test.skip=true
```

- Build native image example

```bash
d run --rm \
-v $M2_HOME:/maven \
-v $HOME/.m2/:/root/.m2 \
-v $PWD/demo:/workspace \
registry.cn-shenzhen.aliyuncs.com/wl4g/graalvm-ce:22.3.0-java17 \
/graalvm-ce/bin/native-image -jar -H:+ReportExceptionStackTraces /workspace/target/demo-0.0.1-SNAPSHOT.jar
```

## 2. Development Guide

```bash
./build.sh build
./build.sh push
```
