# levidge-bitcoin-watching-wallet
watch for bitcoin deposits and withdrawals

# Install bitccoin

Download and unzip latest version from https://bitcoin.org/en/download

# Install supervisor

	$ sudo apt-get install supervisor
	
# Configure supervisor to run bitcoin as a service

Edit the files to be copied below so the path to bitcoin executable and config files for testnet and mainnet are correct. Then...


	thomas@levidge-do1:~/levidge-bitcoin-watching-wallet$ sudo cp dotfiles/etc/supervisor/conf.d/bitcoind* /etc/supervisor/conf.d/

# Add addresses to Watch

### Add addresseses to watch, command line (Modify and run accordingly...)
	thomas@levidge-do1:~/levidge-bitcoin-watching-wallet$ cat addBitcoindWatchingAddressesTestnet.sh 
	#!/bin/bash
	
	# ~/installs/Electrum-3.2.2/electrum --testnet -w ~/.electrum/testnet/wallets/levidge_testnet_multisig_viewing 	listaddresses | jq --monochrome-output --raw-output  '.[]' | while read address
	cat levidge_thomas_trezor_singlesig_testnet_addresses.txt | jq --monochrome-output --raw-output  '.[]' | while read address
	do
	  ~/levidgeWork/addBitcoindWatchingAddressTestnet.sh $address  
	done

# Listen for new addresses dynamically

Haven't done this yet

# Configure reporting wallet transactions to levidge exchange server

Haven't done this yet
