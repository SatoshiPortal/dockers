#!/bin/sh

# Must be logged to docker hub:
# docker login -u cyphernode

# Must enable experimental cli features
# "experimental": "enabled" in ~/.docker/config.json

image() {
  local arch=$1

  echo "Building and pushing cyphernode/clightning for $arch tagging as ${version}..."

  docker build --no-cache -t cyphernode/clightning:${arch}-${version} . \
  && docker push cyphernode/clightning:${arch}-${version}

  return $?
}

manifest() {
  echo "Creating and pushing manifest for cyphernode/clightning for version ${version}..."

  docker manifest create cyphernode/clightning:${version} \
                         cyphernode/clightning:${x86_docker}-${version} \
                         cyphernode/clightning:${arm_docker}-${version} \
                         cyphernode/clightning:${aarch64_docker}-${version} \
  && docker manifest annotate cyphernode/clightning:${version} cyphernode/clightning:${arm_docker}-${version} --os linux --arch ${arm_docker} \
  && docker manifest annotate cyphernode/clightning:${version} cyphernode/clightning:${x86_docker}-${version} --os linux --arch ${x86_docker} \
  && docker manifest annotate cyphernode/clightning:${version} cyphernode/clightning:${aarch64_docker}-${version} --os linux --arch ${aarch64_docker} \
  && docker manifest push -p cyphernode/clightning:${version}

  return $?
}

x86_docker="amd64"
arm_docker="arm"
aarch64_docker="arm64"

# Build amd64 and arm64 first, building for arm will trigger the manifest creation and push on hub

#arch_docker=${arm_docker}
#arch_docker=${aarch64_docker}
arch_docker=${x86_docker}

version="v0.9.1"

echo "arch_docker=$arch_docker"

image ${arch_docker}

[ $? -ne 0 ] && echo "Error" && exit 1

[ "${arch_docker}" = "${x86_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${aarch64_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${arm_docker}" ] && echo "Built and pushed images, now building and pushing manifest for all archs..."

manifest

[ $? -ne 0 ] && echo "Error" && exit 1
