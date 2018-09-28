echo getting transaction $1                                          >> /home/thomas/exchangeWalletUpdatesTestnet.txt
~/installs/bitcoin-0.16.3/bin/bitcoin-cli -testnet gettransaction $1 >> /home/thomas/exchangeWalletUpdatesTestnet.txt
echo decoding transaction $1
~/installs/bitcoin-0.16.3/bin/bitcoin-cli -testnet decoderawtransaction `~/installs/bitcoin-0.16.2/bin/bitcoin-cli -testnet getrawtransaction %1`



