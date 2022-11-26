# Copyright 2017 ~ 2025 the original authors James Wong. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# https://github.com/graalvm/graalvm-ce-builds/releases/
FROM ubuntu:20.04
LABEL maintainer="James Wong<jameswong1376@gmail.com>"

WORKDIR /workspace

COPY materials/graalvm-ce/ /graalvm-ce/

RUN sed -i 's/http:\/\/cn.archive.ubuntu.com\/ubuntu/http:\/\/mirrors.aliyun.com\/ubuntu/g' /etc/apt/sources.list \
&& apt update \
&& apt install -y gcc \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& chmod -R 777 /graalvm-ce \
&& echo 'export GRAALVM_HOME=/graalvm-ce' >> /etc/profile.d/graalvm.sh \
&& echo 'export PATH=$PATH:$GRAALVM_HOME/bin' >> /etc/profile.d/graalvm.sh \
&& . /etc/profile \
&& gu --version \
&& gu install native-image \
# Must be >=22.2.0 to be required
&& [ -z "\$(gu list|grep Graal.js)" ] && gu install js || echo \
&& for f in $(ls /graalvm-ce/bin/); do ln -sf /graalvm-ce/bin/$f /bin/$f; done