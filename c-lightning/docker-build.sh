#!/bin/bash

# Must be logged to docker hub:
# docker login -u cyphernode

# Must enable experimental cli features
# "experimental": "enabled" in ~/.docker/config.json

image() {
  local arch=$1

  echo "Building and pushing cyphernode/clightning for $arch tagging as ${version}..."

  docker build -t cyphernode/clightning:${arch}-${version} . \
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

version="v23.11.2-pg"

# Build amd64 and arm64 first, building for arm will trigger the manifest creation and push on hub

echo -e "\nBuild Core Lightning ${version} for:\n"
echo "1) AMD 64 bits (Most PCs)"
echo "2) ARM 64 bits (Mac M1, RPi4)"
echo "3) ARM 32 bits (RPi2-3)"
echo -en "\nYour choice (1, 2, 3): "
read arch_input

case "${arch_input}" in
  1)
    arch_docker=${x86_docker}
    ;;
  2)
    arch_docker=${aarch64_docker}
    ;;
  3)
    arch_docker=${arm_docker}
    ;;
  *)
    echo "Not a valid choice."
    exit 1
    ;;
esac

echo -e "\nBuilding Core Lightning container\n"
echo "arch_docker=$arch_docker"

image ${arch_docker}

[ $? -ne 0 ] && echo "Error" && exit 1

[ "${arch_docker}" = "${x86_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${aarch64_docker}" ] && echo "Built and pushed ${arch_docker} only" && exit 0
[ "${arch_docker}" = "${arm_docker}" ] && echo "Built and pushed images, now building and pushing manifest for all archs..."

manifest

[ $? -ne 0 ] && echo "Error" && exit 1
