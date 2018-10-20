{-# Language ScopedTypeVariables #-} 
import Control.Monad 
import System.Process ( readProcess, readProcessWithExitCode ) -- todo, use readProcessWithExitCode exclusively
import GHC.IO.Exception ( ExitCode (..) )
import System.FilePath ( (</>) )
import System.Environment (getArgs)
import System.Directory (getHomeDirectory)
import Control.Concurrent (threadDelay)
import Data.List (intersperse)
import Data.Int (Int64)
import Text.Printf (printf)
import Safe (readMay)

main = program 

-- see handleConfirmingTransactionsTestnet.sh for usage infos
program = do
  args <- getArgs
  case args of
    [ btcConfigFile, transactionsCsvFile, confirmingTransactionsFile, userId, strInstrumentId, symbol ] -> do
      currentdir <- pure chomp <*> readProcess "pwd" [] "" 
      -- let configFile = currentdir </> "dotfiles/.bitcoin/bitcointestnet.conf"
      let mbId = readMay strInstrumentId
      case mbId of
          Nothing -> putStrLn $ "stInstrumentId parse probm: " ++ strInstrumentId
          Just instrumentId -> do
          forever $ do
              let confirmingTransactionsFile = "confirmingTransactionsTestnet.txt"
              txids <- (pure lines) <*> (readFile confirmingTransactionsFile)
              forM_ txids $ \txid -> handleTransaction btcConfigFile transactionsCsvFile confirmingTransactionsFile  userId instrumentId symbol txid
              let waitMicroseconds = 1000000
              threadDelay waitMicroseconds
    badArgs -> error $ "handleConfirmingTransactionsTestnet, bad args. Usage is    handleConfirmingTransactionsTestnet btcConfigFile transactionsCsvFile confirmingTransactionsFile userId instrumentId symbol"


maxConfirms :: Integer
maxConfirms = 6 -- todo, make config file var

-- todo, use something safe instead of read
-- todo, review for other unsafe methods

handleTransaction :: FilePath -> FilePath -> FilePath -> String -> Integer -> String -> String -> IO ()
handleTransaction configFile transactionsCsvFile confirmingTransactionsFile userId instrumentId symbol txid = do
  {- let userId = "Not sure what Userid"
      instrumentId :: Integer
      instrumentId = 3 
      symbol = "BTC" -}
  mbTxJson <- bitcoinCli configFile ["gettransaction", txid]
  case mbTxJson of
    Nothing -> putStrLn $ "error with gettransaction for " ++ txid
    Just txJson -> do
      (confirmations :: Integer) <- pure read <*> jqReadKey "confirmations" txJson 
      if confirmations <= maxConfirms
        then do
          walletConflicts <- jqReadKey "walletconflicts" txJson
          -- todo, probably want to send time stuff too.
          -- https://bitcoin.stackexchange.com/questions/10732/what-is-the-difference-between-time-blocktime-and-timereceived/12091
          blocktime <- jqReadKey "blocktime" txJson
          timeReceived <- jqReadKey "timereceived" txJson
          time <- jqReadKey "time" txJson
          -- putStrLn $ "time stuff: " ++ show (timeReceived, blocktime, time)
          mbTxRaw <- bitcoinCli configFile ["getrawtransaction", txid]
          case mbTxRaw of
            Nothing -> putStrLn $ "error with getrawtransaction for " ++ txid
            Just txRaw -> do
              mbTxRawJson <- bitcoinCli configFile ["decoderawtransaction", txRaw]
              case mbTxRawJson of
                Nothing -> putStrLn $ "error with decoderawtransaction for " ++ txRaw
                Just txRawJson -> do
                  putStrLn txRawJson
                  txOuts <- pure lines <*> jqParseTxOuts txRawJson
                  forM_ txOuts $ \txOut -> do
                    putStrLn txOut
                    (addresses :: [String]) <- pure read <*> jqReadKey "addresses" txOut
                    -- putStrLn $ "addresses: " ++  show addresses
                    (txOutType :: String) <- pure read <*> jqReadKey "type" txOut 




                    -- todo, withdrawal from exchange to an address on exchange should NOT COUNT AS A DEPOSIT
                    -- I think we might be double counting these currently. Make sure that is not the case.
                    ( balance_change_bitcoin_64BitPrecision :: Double ) <- pure read <*> jqReadKey "balance_change" txOut 
                    putStrLn $ "balance_change_bitcoin_64BitPrecision: " ++ show balance_change_bitcoin_64BitPrecision
                    -- todo, chris wants to use floats instead of integers. discuss to make sure this won't cause problems. seems wrong to me. 
                    -- I think we should be using balance_change_satoshis as follows. currently not used.
                    -- https://en.bitcoin.it/wiki/Proper_Money_Handling_(JSON-RPC)
                    -- https://en.wikipedia.org/wiki/Double-precision_floating-point_format
                    ( balance_change_satoshis :: Integer ) <- return . toInteger . read . filter (not . (=='.')) . printf "%.8f" $ balance_change_bitcoin_64BitPrecision

                    ( txoutIndex :: Integer ) <- pure read <*> jqReadKey "txOutIndex" txOut 
                    if (txOutType == "scripthash" && length addresses == 1) -- todo, could check that address is in wallet. (optional but desirable)
                      then do
                        -- todo, weird things happen if funds are sent to an electrum wallet change address, since this was never added to the list of watching address
                        -- this should never happen in practice. and if it does, the only effect is we have unaccounted for extra money.
                        -- still, feels like I should think about this a little harder... am I missing anything?
                        let address = head addresses -- todo, OCD type wankery, use a safe head
                        -- This will cause problems. 
                        let confirmationsForBalance = 1
                        mbBalance <- bitcoinCli configFile ["getreceivedbyaddress",address, show confirmationsForBalance]
                        case mbBalance of
                          Nothing -> putStrLn $ "error with getreceivedbyaddress for " ++ address
                          Just strBalance -> do
                            let balance_bitcoin_64BitPrecision :: Double
                                balance_bitcoin_64BitPrecision = read strBalance
                            putStrLn $ "balance: " ++ show balance_bitcoin_64BitPrecision
                            putStrLn $ "about to write csv: " ++ transactionsCsvFile
                            let csvLine = ( concat . intersperse "," $    
                                  [ userId,
                                    show instrumentId,
                                    symbol,
                                    address,
                                    txid,
                                    show balance_bitcoin_64BitPrecision,
                                    show balance_change_bitcoin_64BitPrecision,
                                    show confirmations,
                                    show txoutIndex ] ) ++ "\n"
                            putStrLn csvLine
                            appendFile transactionsCsvFile csvLine
                      else putStrLn $ show (txOutType, addresses)
        else do -- more than maxConfirms, safe to remove txid from confirming transactions file
          readProcess "./removeConfirmedTransaction.sh"  ([txid, confirmingTransactionsFile ]) "" 
          return ()


bitcoinCli :: String -> [String] -> IO (Maybe String)
bitcoinCli configFile args = do
  ( exitCode, stdout, stderr) <- readProcessWithExitCode "bitcoin-cli" ([ "-conf=" ++ configFile] ++ args) "" 
  case exitCode of
    ExitFailure code -> do
      putStrLn $ "error in bitcoinCli " ++ show args ++ ", ExitCode: " ++ show code ++ ", stderr is: :" ++ chomp stderr
      return Nothing
    ExitSuccess -> return . Just . chomp $ stdout

jqReadKey :: [Char] -> String -> IO String
jqReadKey k jsonHash = pure chomp <*> readProcess "jq" [ "{" ++ k ++ "} | to_entries | map (.value) | .[0]" ] jsonHash

chomp :: String -> String
chomp s = case reverse s of
  [] -> []
  '\n' : reverseXs -> reverse reverseXs
  xs -> reverse xs



jqParseTxOuts txRawJson =
  readProcess "jq" [ "--compact-output", " {vout} | .[] | map ({balance_change: .value, txOutIndex: .n, type: .scriptPubKey.type, addresses: .scriptPubKey.addresses }) | .[] " ] txRawJson



-- bitcoinsToSatoshis :: Int64 -> Integer
-- bitcoinsToSatoshis bitcoins = {- toInteger . filter (not . (=='.') ) . -} show .  printf "%.8f" $ bitcoins

t1, t2 :: IO ()
t1 = tFunc "58dea6e73f4f1d6fa4fe499bc497de352ac9faf95c9dd6b0efe43a19765e741f"
t2 = tFunc "dee6e5ea348b370081e7c86d1c09a958546cfd51188ec969dd1c31cf9d7b0218"
t3 = putStrLn "arrrggg"

tFunc :: String -> IO ()
tFunc = handleTransaction ( "/home/thomas/levidge-bitcoin-watching-wallet/dotfiles/.bitcoin/bitcointestnet.conf" ) "/home/thomas/watchers/btc/transactions.csv" "confirmingTransactionsTestnet.txt" "not sure" 6 "BTCTEST"


{-
#while true
#do
    
                    # todo, test blank inputs, non txid inputs
                          confirmations=`./getConfirmations.sh $configFile "$txid"`
                                # todo, understand this better. possibly there should be louder alarms set off here if there is conflict... email site owners or something.
                                      conflicts=`./getConflicts.sh $configFile "$txid"`


      echo confirmations: $confirmations
            if [ $confirmations -le $MAX_CONFIRMATIONS ]
                  then
                             ./handleConfirmingTransaction.sh $configFile $txid $CONFIRMING_TRANSACTIONS_FILE
                                   else
                                             ./removeConfirmedTransaction.sh "$txid" $CONFIRMING_TRANSACTIONS_FILE
                                                   fi
                                                       done # next txid
                                                           #sleep 10
                                                           #done # keep looping forever

-}

