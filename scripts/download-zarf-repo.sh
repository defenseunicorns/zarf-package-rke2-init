#!/bin/bash
set -ex

pwd

rm -rf "${1}"

wget -o /dev/null https://github.com/defenseunicorns/zarf/archive/refs/tags/v0.24.2.tar.gz -O zarf.tar.gz

mkdir -p "${1}"

tar -xf zarf.tar.gz -C "${1}"

rm -rf zarf.tar.gz

mv ${1}/zarf-0.24.2/* "${1}"

rm -rf "${1}/zarf-*/"