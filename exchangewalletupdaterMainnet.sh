echo getting transaction $1                                          >> /home/thomas/exchangeWalletUpdatesMainnet.txt
~/installs/bitcoin-0.16.2/bin/bitcoin-cli -testnet gettransaction $1 >> /home/thomas/exchangeWalletUpdatesMainnet.txt

