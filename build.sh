#!/bin/bash
# Copyright 2017 ~ 2025 the original authors <jameswong1376@gmail.com>. 
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
set -e

export BASE_DIR=$(cd "`dirname $0`"/; pwd)
export OS_NAME=${OS_NAME:-linux}
export ARCH_NAME=${ARCH_NAME:-amd64}
export JAVA_VERSION=${JAVA_VERSION:-java17}
export GRAALVM_VERSION=${GRAALVM_VERSION:-22.3.0}
export BUILD_IMAGE_VERSION="${GRAALVM_VERSION}-${JAVA_VERSION}"

function print_help() {
  echo $"
Usage: ./$(basename $0) [OPTIONS] [arg1] [arg2] ...
    build              Build of graalvm image.
    push               Push the graalvm image to repoistory.
          <repo_uri>   Push to repoistory uri. format: <registryUri>/<namespace>, e.g: registry.cn-shenzhen.aliyuncs.com/wl4g
"
}

function build_images() {
  mkdir -p ${BASE_DIR}/materials/
  local graalvmDir="${BASE_DIR}/materials/graalvm-ce"
  echo "Checking ${graalvmDir} ..."
  if [ ! -d "${graalvmDir}" ]; then
    local graalvmTarFile="${BASE_DIR}/materials/graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION}.tar.gz"
    echo "Checking ${graalvmTarFile} ..."
    if [ ! -f "$graalvmTarFile" ]; then
      echo "Downloading graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION} tar ..."
      curl -o ${BASE_DIR}/materials/graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION}.tar.gz -L "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION}.tar.gz"
    fi
    echo "Unpacking graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION}.tar.gz ..."
    cd ${BASE_DIR}/materials/ \
        && mkdir graalvm-ce \
        && tar -xvf graalvm-ce-${JAVA_VERSION}-${OS_NAME}-${ARCH_NAME}-${GRAALVM_VERSION}.tar.gz --strip-components=1 -C graalvm-ce
  fi

  echo "Building ${BUILD_IMAGE_VERSION} images ..."
  cd $BASE_DIR && docker build -t wl4g/graalvm-ce:${BUILD_IMAGE_VERSION} .
}

function push_images() {
  local repo_uri="$1"
  [ -z "$repo_uri" ] && repo_uri="docker.io/wl4g"
  ## FIX: Clean up suffix delimiters for normalization '/'
  repo_uri="$(echo $repo_uri | sed -E 's|/$||g')"

  echo "Tagging images to $repo_uri ..."
  docker tag wl4g/graalvm-ce:${BUILD_IMAGE_VERSION} $repo_uri/graalvm-ce:${BUILD_IMAGE_VERSION}
  docker tag wl4g/graalvm-ce:${BUILD_IMAGE_VERSION} $repo_uri/graalvm-ce:latest

  echo "Pushing images of ${BUILD_IMAGE_VERSION}@$repo_uri ..."
  docker push $repo_uri/graalvm-ce:${BUILD_IMAGE_VERSION} &

  echo "Pushing images of latest@$repo_uri ..."
  docker push $repo_uri/graalvm-ce &

  wait
}

# --- Main. ---
case $1 in
  build)
    build_images
    ;;
  push)
    push_images "$2"
    ;;
  *)
    print_help
    ;;
esac
