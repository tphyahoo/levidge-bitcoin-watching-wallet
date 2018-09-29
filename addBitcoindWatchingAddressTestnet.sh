source levidge-bitcoin-watching-wallet.env
bitcoin-cli -conf=/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf -testnet  importmulti "
  [
    {
      \"scriptPubKey\" : { \"address\": \"$1\" },
      \"timestamp\" : \"now\",
      \"label\" : \"$2\"
    }        
  ]" "{ \"rescan\": false }"
