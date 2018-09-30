#!/bin/bash -uex
date
echo posix time: `date +%s`
echo getting transaction $1
bitcoin-cli -conf=/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf -testnet gettransaction $1 
echo decoding transaction $1
bitcoin-cli -conf=/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf -testnet decoderawtransaction `bitcoin-cli -conf=/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf -testnet getrawtransaction $1` 




