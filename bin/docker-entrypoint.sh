#!/bin/bash

set -exuo pipefail

BITCOIN_DIR=/bitcoin
BITCOIN_CONF=${BITCOIN_DIR}/.bitcoin/bitcoin.conf


if [ ! -e "${BITCOIN_CONF}" ]; then
  cat >${BITCOIN_CONF} <<EOF

# server=1 tells Bitcoin-Qt and bitcoind to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${BTC_RPCUSER:-btc}
rpcpassword=${BTC_RPCPASSWORD:-changemeplz}

# How many seconds bitcoin will wait for a complete RPC HTTP request.
# after the HTTP connection is established.
rpcclienttimeout=${BTC_RPCCLIENTTIMEOUT:-30}

rpcallowip=${BTC_RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${BTC_RPCPORT:-8332}

# Print to console (stdout) so that "docker logs bitcoind" prints useful
# information.
printtoconsole=${BTC_PRINTTOCONSOLE:-1}

# We probably don't want a wallet.
disablewallet=1

# Enable an on-disk txn index. Allows use of getrawtransaction for txns not in
# mempool.
txindex=1

blocksonly=1
dbcache=20
maxsigcachesize=4
maxconnections=4
rpcthreads=1
EOF
fi

if [ $# -eq 0 ]; then
  exec bitcoind -datadir=${BITCOIN_DIR} -conf=${BITCOIN_CONF}
else
  exec "$@"
fi

