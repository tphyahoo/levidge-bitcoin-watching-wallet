#!/bin/bash -uex

. env.sh

txid=$1

echo $txid >> $CONFIRMING_TRANSACTIONS_FILE
