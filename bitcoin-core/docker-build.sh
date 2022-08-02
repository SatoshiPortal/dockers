#!/bin/bash

# Must be logged to docker hub:
# docker login -u cyphernode

# Must enable experimental cli features
# "experimental": "enabled" in ~/.docker/config.json

image() {
  local arch=$1
  local arch2=$2

  echo "Building and pushing cyphernode/bitcoin for $arch tagging as ${version} alpine arch ${arch2}..."

  docker build --no-cache -t cyphernode/bitcoin:${arch}-${version} --build-arg ARCH=${arch2} . \
  && docker push cyphernode/bitcoin:${arch}-${version}

  return $?
}

manifest() {
  echo "Creating and pushing manifest for cyphernode/bitcoin for version ${version}..."

  docker manifest create cyphernode/bitcoin:${version} \
                         cyphernode/bitcoin:${x86_docker}-${version} \
                         cyphernode/bitcoin:${arm_docker}-${version} \
                         cyphernode/bitcoin:${aarch64_docker}-${version} \
  && docker manifest annotate cyphernode/bitcoin:${version} cyphernode/bitcoin:${arm_docker}-${version} --os linux --arch ${arm_docker} \
  && docker manifest annotate cyphernode/bitcoin:${version} cyphernode/bitcoin:${x86_docker}-${version} --os linux --arch ${x86_docker} \
  && docker manifest annotate cyphernode/bitcoin:${version} cyphernode/bitcoin:${aarch64_docker}-${version} --os linux --arch ${aarch64_docker} \
  && docker manifest push -p cyphernode/bitcoin:${version}

  return $?
}

x86_docker="amd64"
x86_alpine="x86_64"
arm_docker="arm"
arm_alpine="arm"
aarch64_docker="arm64"
aarch64_alpine="aarch64"

version="v23.0-mosquitto-debian"

# Build amd64 and arm64 first, building for arm will trigger the manifest creation and push on hub

echo -e "\nBuild Bitcoin Core ${version} for:\n"
echo "1) AMD 64 bits (Most PCs)"
echo "2) ARM 64 bits (Mac M1, RPi4)"
echo "3) ARM 32 bits (RPi2-3)"
echo -en "\nYour choice (1, 2, 3): "
read arch_input

case "${arch_input}" in
  1)
    arch_docker=${x86_docker}
    arch_alpine=${x86_alpine}
    ;;
  2)
    arch_docker=${aarch64_docker}
    arch_alpine=${aarch64_alpine}
    ;;
  3)
    arch_docker=${arm_docker}
    arch_alpine=${arm_alpine}
    ;;
  *)
    echo "Not a valid choice."
    exit 1
    ;;
esac

echo -e "\nBuilding Bitcoin Core container\n"
echo "arch_docker=$arch_docker"
echo -e "arch_alpine=$arch_alpine\n"

image ${arch_docker} ${arch_alpine}

[ $? -ne 0 ] && echo "Error" && exit 1

[ "${arch_docker}" = "${x86_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${aarch64_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${arm_docker}" ] && echo "Built and pushed images, now building and pushing manifest for all archs..."

manifest

[ $? -ne 0 ] && echo "Error" && exit 1
