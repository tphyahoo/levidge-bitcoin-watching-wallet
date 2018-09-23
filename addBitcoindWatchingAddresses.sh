#!/bin/bash

# ~/installs/Electrum-3.2.2/electrum --testnet -w ~/.electrum/testnet/wallets/levidge_testnet_multisig_viewing listaddresses | jq --monochrome-output --raw-output  '.[]' | while read address
cat levidge_thomas_trezor_singlesig_testnet_addresses.txt | jq --monochrome-output --raw-output  '.[]' | while read address
do
  ~/levidgeWork/addBitcoindWatchingAddress.sh $address  
done
