#!/usr/bin/env bash

set -eux
set -o pipefail

# Arguments: $1 = program, $2 = version of program, $3 = platform, $4 = install directory, $5 = check the GPG signature
if [ $# -ne 5 ]; then
  echo "Not enough arguments supplied"
  exit 1
fi

HASHICORP_PROGRAM=$1
HASHICORP_VERSION=$2
HASHICORP_PLATFORM=$3
INSTALL_PATH=$4
GPG_CHECK=$5
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

if [[ $GPG_CHECK == "true" ]]; then
  gpg --verify ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS.sig ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS

  if [ $? -ne 0 ]; then
    echo "GPG did not match"
    exit 1
  fi
fi

cat ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS  | grep $HASHICORP_FILE > ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS_PLATFORM_ONLY
shasum -a 256 -c ${HASHICORP_PROGRAM}_${HASHICORP_VERSION}_SHA256SUMS_PLATFORM_ONLY

if [ $? -eq 0 ]; then
  mv ${HASHICORP_PROGRAM} $INSTALL_PATH/${HASHICORP_PROGRAM}
else
  echo "Checksum did not match"
  exit 1
fi
