#!/bin/bash

# Adapted from https://github.com/rancher/rke2/blob/master/scripts/package-images
# This was to replicate normal rke2 image archives as close as possible so that rke2 is okay with importing them

set -ex

mkdir -p tmp

IMAGES_FILE='tmp/longhorn-images.txt'

cat ../zarf/examples/longhorn/zarf.yaml | yq .components[].images[] > ${IMAGES_FILE}

# We reorder the tar file so that the metadata files are at the start of the archive, which should make loading
# the runtime image faster. By default `docker image save` puts these at the end of the archive, which means the entire
# tarball needs to be read even if you're just loading a single image.

BASE=$(basename ${IMAGES_FILE} .txt)
DEST=tmp/${BASE}.tar
cat ${IMAGES_FILE} | xargs -n1 docker pull
docker image save --output ${DEST}.tmp $(<${IMAGES_FILE})
bsdtar -c -f ${DEST} --include=manifest.json --include=repositories @${DEST}.tmp
bsdtar -r -f ${DEST} --exclude=manifest.json --exclude=repositories @${DEST}.tmp
rm -f ${DEST}.tmp

BASE=$(basename ${IMAGES_FILE} .txt)
TARFILE=tmp/${BASE}.tar
zstd -T0 -16 -f --long=25 --no-progress ${TARFILE} -o files/longhorn_images.tar.zst

rm -rf tmp