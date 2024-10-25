#!/usr/bin/env bash
set -e -o pipefail

ADDITIONAL_ARGUMENTS=()
if [[ -n "$PROXY_URL" ]]; then
    ADDITIONAL_ARGUMENTS+=("--socks5" "${PROXY_URL#socks5://}")
fi

set -x
p2pool "${ADDITIONAL_ARGUMENTS[@]}" --host "$MONERO_NODE_ADDRESS" --light-mode \
    --stratum 0.0.0.0:3333 --wallet "$WALLET_ADDRESS" "$@"
