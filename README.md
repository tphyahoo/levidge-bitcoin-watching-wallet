# levidge-bitcoin-watching-wallet
watch for bitcoin deposits and withdrawals

# Install bitccoin

Download and unzip latest version from https://bitcoin.org/en/download

Currently doing this in home directory of my (thomas) user. Trying to avoid installing ssoftware as root.

# Install supervisor

	$ sudo apt-get install supervisor
	
# Configure supervisor to run bitcoin as a service

Edit the files to be copied below so the path to bitcoin executable and config files for testnet and mainnet are correct. Then...


	levidge-do1:~/levidge-bitcoin-watching-wallet$ sudo cp dotfiles/etc/supervisor/conf.d/bitcoind* /etc/supervisor/conf.d/

# Add addresses to Watch

### Add addresseses to watch, command line (Modify and run accordingly...)
	levidge-sh1:~/levidge-bitcoin-watching-wallet$ ./addBitcoindWatchingAddressesTestnet.sh 

This is flaky now. Generally to get it to work on a new box I tar.gz and copy over a working ~/.bitcoin dir from an existing server.

I believe that it would also work if I ran this script at start time, before downloading blocks. 

I believe there is also a way to get it to work on an empty wallet after downloading blocks, by using -reindex flag. 
Needs more testing.

# Listen for new addresses dynamically

Haven't done this yet

# Configure reporting wallet transactions to levidge exchange server

Haven't done this yet. However, note that this is controlled by the walletnotify line in the bitcoin config file. 

	levidge-do1:~/levidge-bitcoin-watching-wallet$ tail -n3 dotfiles/.bitcoin/bitcointestnet.conf 
	walletnotify=/home/thomas/levidge-bitcoin-watching-wallet/exchangewalletupdaterTestnet.sh %s >> /home/thomas/exchangeWalletUpdatesTestnet.txt
	
	
