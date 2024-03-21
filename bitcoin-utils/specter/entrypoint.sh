#!/bin/sh

if [ ! -d "/.specter/nodes/" ]; then
  mkdir -p "/.specter/nodes/"
fi

# create the config for bitcoin rpc connection if it doesn't exist
if [ ! -f "/.specter/nodes/bitcoin.json" ]; then
  user=$(grep -m 1 'rpcuser=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)
  password=$(grep -m 1 'rpcpassword=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)
  host=$(grep -m 1 'rpcconnect=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)

  if grep -q 'testnet=1' /.bitcoin/bitcoin.conf; then
    port=$(grep -m 1 'test.rpcport=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)
  elif grep -q 'regtest=1' /.bitcoin/bitcoin.conf; then
    port=$(grep -m 1 'regtest.rpcport=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)
  else
    port=$(grep -m 1 'main.rpcport=' /.bitcoin/bitcoin.conf | cut -d'=' -f2)
  fi

  json_template='{
    "python_class": "cryptoadvance.specter.node.Node",
    "fullpath": "/.specter/nodes/bitcoin.json",
    "name": "bitcoin",
    "alias": "bitcoin",
    "autodetect": false,
    "datadir": "",
    "user": "'$user'",
    "password": "'$password'",
    "port": "'$port'",
    "host": "'$host'",
    "protocol": "http",
    "node_type": "BTC"
  }'

  echo "$json_template" > /.specter/nodes/bitcoin.json
fi

ip=${1}

[ -n "${ip}" ] && exec python3 -m cryptoadvance.specter server --specter-data-folder /.specter --host ${ip} 
[ -z "${ip}" ] && exec python3 -m cryptoadvance.specter server --specter-data-folder /.specter 

