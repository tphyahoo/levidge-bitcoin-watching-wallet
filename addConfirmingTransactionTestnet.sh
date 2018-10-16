#!/bin/bash -uex

. envTestnet.sh

txid=$1

echo $txid >> $ALL_TRANSACTIONS_FILE
echo $txid >> $CONFIRMING_TRANSACTIONS_FILE
