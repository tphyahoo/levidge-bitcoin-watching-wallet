date +%s; date; 
bitcoin-cli -conf=`pwd`/dotfiles/.bitcoin/bitcointestnet.conf getblockchaininfo | head; bitcoin-cli -conf=`pwd`/dotfiles/.bitcoin/bitcoinmainnet.conf getblockchaininfo | head
