#!/bin/bash
# create new electrum addresses
# usage, creeateNewElectrumAddresses 10 creates 10 new addresses

counter=1
while [ $counter -le $1 ]
do
    echo $counter
    electrum --testnet -w ~/.electrum/testnet/wallets/levidge_testnet_multisig_watching_wallet createnewaddress
    ((counter++))
done

