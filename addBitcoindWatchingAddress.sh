~/installs/bitcoin-0.16.2/bin/bitcoin-cli -testnet  importmulti "
  [
    {
      \"scriptPubKey\" : { \"address\": \"$1\" },
      \"timestamp\" : \"now\",
      \"label\" : \"$2\"
    }        
  ]" "{ \"rescan\": false }"
