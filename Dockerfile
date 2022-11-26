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

RUN chmod -R 777 /graalvm-ce \
&& echo 'export GRAALVM_HOME=/graalvm-ce' >> /etc/bash.bashrc \
&& echo 'export PATH=$PATH:$GRAALVM_HOME/bin' >> /etc/bash.bashrc \
&& . /etc/bash.bashrc \
&& cat /etc/bash.bashrc \
&& gu install -y native-image js \
&& echo "Asia/Shanghai" > /etc/timezone

ENTRYPOINT [ "native-image" ]