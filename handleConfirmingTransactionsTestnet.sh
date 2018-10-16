#!/bin/bash -uex

. envTestnet.sh 

while true
do
    cat $CONFIRMING_TRANSACTIONS_FILE | while read txid
    do
      confirmations=`./getConfirmations.sh "$txid"` # todo, test blank inputs, non txid inputs
      echo confirmations: $confirmations
      
      if [ $confirmations -le $MAX_CONFIRMATIONS ] 
      then
	   ./handleConfirmingTransaction.sh $txid $CONFIRMING_TRANSACTIONS_FILE 
      else
	  ./removeConfirmedTransaction.sh "$txid" $CONFIRMING_TRANSACTIONS_FILE
      fi
    done # next txid
    sleep 10
done # keep looping forever

