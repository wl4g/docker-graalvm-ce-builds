# Docker GraalVM builder images

## 1. Quick start

- Show plugins

```bash
alias d='docker'
d run --rm wl4g/graalvm-ce:22.3.0-java17 /graalvm-ce/bin/gu list
```

- Build with Maven example

```bash
d run --rm \
-v $M2_HOME:/maven \
-v $HOME/.m2/:/root/.m2 \
-v $PWD/myproject:/workspace \
registry.cn-shenzhen.aliyuncs.com/wl4g/graalvm-ce:22.3.0-java17 \
/maven/bin/mvn -U -T 2C clean package -DskipTests -Dmaven.test.skip=true
```

- Build native image example

```bash
d run --rm \
-v $M2_HOME:/maven \
-v $HOME/.m2/:/root/.m2 \
-v $PWD/myproject:/workspace \
registry.cn-shenzhen.aliyuncs.com/wl4g/graalvm-ce:22.3.0-java17 \
/graalvm-ce/bin/native-image -jar -H:+ReportExceptionStackTraces /workspace/target/myproject-0.0.1-SNAPSHOT.jar
```

## 2. Development Guide

```bash
git clone git@github.com:wl4g/graalvm-ce-builds.git
cd graalvm-ce-builds
./build.sh build
./build.sh push
```
