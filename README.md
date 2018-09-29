# levidge-bitcoin-watching-wallet
watch for bitcoin deposits and withdrawals

# Install bitccoin

Download and unzip latest version from https://bitcoin.org/en/download

Currently doing this in home directory of my (thomas) user. Trying to avoid installing sensitive software as root.

# Install supervisor

	$ sudo apt-get install supervisor
	
# Configure supervisor to run bitcoin as a service

Edit the files to be copied below so the path to bitcoin executable and config files for testnet and mainnet are correct. Then...


	levidge-do1:~/levidge-bitcoin-watching-wallet$ sudo cp dotfiles/etc/supervisor/conf.d/bitcoind* /etc/supervisor/conf.d/

# Add addresses to Watch

### Add addresseses to watch, command line (Modify and run accordingly...)
	levidge-do1:~/levidge-bitcoin-watching-wallet$ cat addBitcoindWatchingAddressesTestnet.sh 
	#!/bin/bash
	
	# ~/installs/Electrum-3.2.2/electrum --testnet -w ~/.electrum/testnet/wallets/levidge_testnet_multisig_viewing 	listaddresses | jq --monochrome-output --raw-output  '.[]' | while read address
	cat levidge_thomas_trezor_singlesig_testnet_addresses.txt | jq --monochrome-output --raw-output  '.[]' | while read address
	do
	  ~/levidgeWork/addBitcoindWatchingAddressTestnet.sh $address  
	done

# Listen for new addresses dynamically

Haven't done this yet

# Configure reporting wallet transactions to levidge exchange server

Haven't done this yet. However, note that this is controlled by the walletnotify line in the bitcoin config file. 

	levidge-do1:~/levidge-bitcoin-watching-wallet$ tail -n3 dotfiles/.bitcoin/bitcointestnet.conf 
	walletnotify=/home/thomas/levidge-bitcoin-watching-wallet/exchangewalletupdaterTestnet.sh %s >> /home/thomas/exchangeWalletUpdatesTestnet.txt
	
	
