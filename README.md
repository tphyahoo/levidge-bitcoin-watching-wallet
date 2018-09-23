# levidge-bitcoin-watching-wallet
watch for bitcoin deposits and withdrawals

# Install bitccoin

# Configure bitcoin

# Add addresses to Watch

### Add addresseses to watch, command line (Modify and run accordingly...)
	thomas@levidge-do1:~/levidge-bitcoin-watching-wallet$ cat addBitcoindWatchingAddresses.sh 
	#!/bin/bash
	# ~/installs/Electrum-3.2.2/electrum --testnet -w ~/.electrum/testnet/wallets/levidge_testnet_multisig_viewing listaddresses | jq --monochrome-output --raw-output  '.[]' | while read address
	cat levidge_thomas_trezor_singlesig_testnet_addresses.txt | jq --monochrome-output --raw-output  '.[]' | while read address
	do
		~/levidgeWork/addBitcoindWatchingAddress.sh $address  
done

# Listen for new addresses dynamically

Haven't done this yet

# Configure reporting wallet transactions to levidge exchange server

Haven't done this yet
