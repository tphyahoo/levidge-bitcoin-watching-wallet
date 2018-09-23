echo getting transaction $1                                          >> /home/thomas/exchangeWalletUpdatesTestnet.txt
~/installs/bitcoin-0.16.2/bin/bitcoin-cli -testnet gettransaction $1 >> /home/thomas/exchangeWalletUpdatesTestnet.txt

