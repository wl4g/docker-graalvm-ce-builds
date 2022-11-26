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

COPY materials/graalvm-ce/ /graalvm-ce/

RUN sed -i 's/http:\/\/cn.archive.ubuntu.com\/ubuntu/http:\/\/mirrors.aliyun.com\/ubuntu/g' /etc/apt/sources.list \
&& apt update \
&& apt install gcc \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& chmod -R 777 /graalvm-ce \
&& echo "export GRAALVM_HOME=/graalvm-ce\nexport PATH=\$PATH:\$GRAALVM_HOME/bin" >> /etc/bash.bashrc \
&& . /etc/bash.bashrc \
&& gu install native-image js \
&& echo "Asia/Shanghai" > /etc/timezone