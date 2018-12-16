# historical note

This repo is not in use and I am not involved in the project anymore.

I have made it public in case it might be useful to anyone (including myelf).

# levidge-bitcoin-watching-wallet
watch for bitcoin deposits and withdrawals

We keep a list of txids that need to be checked. 

Txids are added to the confirmingTransactions file by a shell script called by walletnotify mechanism of bitcoind.
See bitcoin config file walletnotify line for this command.

	levidge-do1:~/levidge-bitcoin-watching-wallet$ tail -n3 dotfiles/.bitcoin/bitcointestnet.conf 
	walletnotify=cd /home/thomas/levidge-bitcoin-watching-wallet ; ./addConfirmingTransactionTestnet.sh %s

handleConfirmingTransactions runs demonized under supervisor:
* watches the confirmingTransactionsFile
* does necessary parsing for confirming transactions
* writes a transactions csv file with deposits and withdrawals 
* deletes txids from the confirmingTransactions file.

Another process, NodeClient, also daemonized under supervisor, watches the transactions csv file and communicates deposits and withdrawals to the levidge server.
NodeClient is in a separate repo for now.

# Install supervisor

	$ sudo apt-get install supervisor

# Install handleConfirmingTransactions 

	apt-get install ghc
	apt-get install cabal-install
	cabal install safe 
	# for parsing json. Todo, remove need to use this command line utility and parse natively using aeson or similar lib.
	apt-get install jq 
	$ ghc --make handleConfirmingTransactions.hs # creates handleConfirmingTransactions executable

# Install handleConfirmingTransactions supervisor config files 

	$ sudo cp dotfiles/etc/supervisor/conf.d/handleConfirmingTransactionsTestnet* /etc/supervisor/conf.d

# Install NodeClient

Not currently well packaged. Just a tar.gz file with a lot of binaries. 

Also requires apt installing a java related library, but I don't remember which one. (todo)

# Install NodeClient supervisor config files 

	sudo cp dotfiles/etc/supervisor/conf.d/btcwatcher.conf /etc/supervisor/conf.d/

Todo: Naming here is confusing. Could use some cleanup. 

# Install bitccoin

Download and unzip latest version from https://bitcoin.org/en/download

Copy them somewhere they are executable system wide

levidge-sh1:~/installs/bitcoin-0.16.3/bin$ sudo cp * /usr/bin/
	
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


	
	
