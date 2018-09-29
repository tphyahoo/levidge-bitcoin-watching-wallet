source levidge-bitcoin-watching-wallet.env
bitcoin-cli -conf=`pwd`/dotfiles/.bitcoin/bitcointestnet.conf -testnet listreceivedbyaddress 0 false true
