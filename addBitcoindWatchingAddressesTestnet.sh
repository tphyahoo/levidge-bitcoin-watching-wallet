#!/bin/bash

# electrum --testnet -w ~/.electrum/testnet/wallets/trezor_singlesig_testnet listaddresses | jq --monochrome-output --raw-output  '.[]' | while read address
cat levidge_thomas_trezor_singlesig_testnet_addresses.txt | jq --monochrome-output --raw-output  '.[]' | while read address
do
  ./addBitcoindWatchingAddressTestnet.sh $address  
done
