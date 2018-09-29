echo getting transaction $1
source levidge-bitcoin-watching-wallet.env
bitcoin-cli -testnet gettransaction $1

