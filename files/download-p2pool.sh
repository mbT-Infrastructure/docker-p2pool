#!/usr/bin/env bash
set -e

RELEASES_JSON_URL="https://api.github.com/repos/SChernykh/p2pool/releases/latest"
RELEASE_VERSION="$(curl --silent --location "$RELEASES_JSON_URL" \
    | grep --max-count 1 "\"tag_name\": " \
    | sed "s|^\s*\".*\": \"\(.*\)\".*\$|\1|")"
PACKAGE_NAME="p2pool-${RELEASE_VERSION}-$(sed --expression 's|/amd|-x|' \
    --expression 's|/arm|-aarch|' <<<"$TARGETPLATFORM").tar.gz"
PACKAGE_URL="https://github.com/SChernykh/p2pool/releases/download/${RELEASE_VERSION}/$PACKAGE_NAME"

download.sh "$PACKAGE_URL" \
    "https://github.com/SChernykh/p2pool/releases/download/${RELEASE_VERSION}/sha256sums.txt.asc" \
  "https://raw.githubusercontent.com/monero-project/gitian.sigs/master/gitian-pubkeys/SChernykh.asc"

gpg --keyring ./signature-public-keys.gpg --no-default-keyring --import SChernykh.asc
gpg --keyring ./signature-public-keys.gpg --no-default-keyring --quiet --verify sha256sums.txt.asc
SHA256SUM="$(grep --after-context 2 "$PACKAGE_NAME" sha256sums.txt.asc | grep "SHA256: " \
    | sed 's|SHA256: ||')"
echo "$SHA256SUM  $PACKAGE_NAME" | sha256sum --check
rm SChernykh.asc sha256sums.txt.asc signature-public-keys.gpg*

compress.sh --decompress "$PACKAGE_NAME"
mv "${PACKAGE_NAME%.tar.gz}/p2pool" .
mv "${PACKAGE_NAME%.tar.gz}/LICENSE" p2pool-license
rm -r "$PACKAGE_NAME" "${PACKAGE_NAME%.tar.gz}"
