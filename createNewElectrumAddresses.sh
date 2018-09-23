#!/bin/bash
# create new electrum addresses
# usage, creeateNewElectrumAddresses 10 creates 10 new addresses

counter=1
while [ $counter -le $1 ]
do
    echo $counter
    electrum -w ~/.electrum/tradeplacer.viewonly createnewaddress
    ((counter++))
done

