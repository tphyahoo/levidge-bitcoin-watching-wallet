#!/bin/bash -uex

TXID=$1
bitcoin-cli -conf=/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf -testnet gettransaction $TXID | jq ' {confirmations} | to_entries | map (.value) | .[0]'
