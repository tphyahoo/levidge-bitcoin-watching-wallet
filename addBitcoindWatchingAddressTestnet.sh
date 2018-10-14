bitcoin-cli -conf=`pwd`/dotfiles/.bitcoin/bitcointestnet.conf -testnet  importmulti "
  [
    {
      \"scriptPubKey\" : { \"address\": \"$1\" },
      \"timestamp\" : \"now\",
      \"label\" : \"$2\"
    }        
  ]" "{ \"rescan\": false }"
