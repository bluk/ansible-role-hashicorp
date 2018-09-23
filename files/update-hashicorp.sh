#!/usr/bin/env bash

set -eux
set -o pipefail

# Arguments: $1 = program, $2 = version of program, $3 = platform, $4 = install directory
if [ $# -ne 4 ]; then
  echo "Not enough arguments supplied"
  exit 1
fi

HASHICORP_PROGRAM=$1
HASHICORP_VERSION=$2
HASHICORP_PLATFORM=$3
INSTALL_PATH=$4
HASHICORP_FILE=${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_${HASHICORP_PLATFORM}.zip
HASHICORP_URL=https://releases.hashicorp.com/${HASHICORP_PROGRAM}/${HASHICORP_VERSION}/${HASHICORP_FILE}
HASHICORP_SHA256SUMS_URL=https://releases.hashicorp.com/${HASHICORP_PROGRAM}/${HASHICORP_VERSION}/${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS
HASHICORP_SHA256SUMS_SIG_URL=https://releases.hashicorp.com/${HASHICORP_PROGRAM}/${HASHICORP_VERSION}/${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS.sig

TMP_DIR=$(mktemp -d)

cd $TMP_DIR
curl -Os $HASHICORP_URL
unzip $HASHICORP_FILE
curl -Os $HASHICORP_SHA256SUMS_URL
curl -Os $HASHICORP_SHA256SUMS_SIG_URL
gpg --keyserver pgp.mit.edu --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C
gpg --verify ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS.sig ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS

cat ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS  | grep $HASHICORP_FILE > ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS_PLATFORM_ONLY
shasum -a 256 -c ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS_PLATFORM_ONLY

if [ $? == 0 ]; then
  mv ${HASHICORP_PROGRAM} $INSTALL_PATH/${HASHICORP_PROGRAM}
else
  echo "Checksum did not match"
fi
