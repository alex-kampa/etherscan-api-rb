class EtherscanAPI

	attr_accessor :print_query

	@@apiAddress = 'https://api.etherscan.io/api'

	def initialize(api_key, sl, h={})
	  @apiKeyToken = api_key
	  @sl = sl
	  @print_query = h.has_key?(:print_query) ? h[:print_query] : false
	  @print_next_query = false
	end
	
	def print_next_query
		@print_next_query = true
	end

=begin

Account APIs - https://etherscan.io/apis#accounts

[x] Get Ether Balance for a single Address => get_balance
[ ] Get Ether Balance for multiple Addresses in a single call
[x[ Get a list of 'Normal' Transactions By Address => get_normal_transactions
[x] [BETA] Get a list of 'Internal' Transactions by Address => get_internal_transactions
[x] Get "Internal Transactions" by Transaction Hash => get_internal_transactions_hash
[ ] Get list of Blocks Mined by Address

Contract APIs - https://etherscan.io/apis#contracts

[x] Get Contract ABI for Verified Contract Source Codes => get_contract_abi

Transaction APIs - https://etherscan.io/apis#transactions

[ ] [BETA] Check Contract Execution Status (if there was an error during contract execution) 

EventLogs

[x] get_eventlog

GETH/Parity Proxy

[x] number of most recent block => get_eth_blockNumber
[ ] information about a block by block number
..

Tokens - https://etherscan.io/apis#tokens

[x] Get ERC20-Token TotalSupply by ContractAddress => get_token_total_supply
[x] Get ERC20-Token Account Balance for TokenContractAddress  => get_token_balance


Stats - https://etherscan.io/apis#stats

[ ] Get Total Supply of Ether
[x] Get ETHER LastPrice Price => get_eth_stats, get_ethbtc, get_ethusd

=end	
	
	
	
	
	###########################################################################
	#
	# Generic
	#
	###########################################################################	

	def submit_query(h)
	
		query = generate_query(h)
		
		@sl.p "query: " + query if @print_query or @print_next_query
		@print_next_query = false
		
		res_raw = RestClient.get(query, {}).body
		res = JSON.parse(res_raw, symbolize_names: true)
		
	end
	
	def generate_query(h)
	
		s = @@apiAddress + '?'
		
		h.keys.each do |key|
			s += "#{key}=#{h[key]}" + '&'
		end
		
		s += "apikey=#{@apiKeyToken}"
	
		return s
		
	end
		
	###########################################################################
	#
	# Accounts
	#
	###########################################################################
	
	def get_balance(address)
	
		# Get Ether Balance for a single Address
		#
		# https://api.etherscan.io/api?
		# module=account&action=balance
		# &address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a
		# &tag=latest
		# &apikey=YourApiKeyToken

		h = {
			:module => 'account',
			:action => 'balance',
			:address => address
		}
		
		res = submit_query(h)
		res[:result].to_i/1.0e18
	
	end

	# =========================================================================
	
	def get_normal_transactions(address, sort='asc', startblock=0, endblock=99999999)
	
		## sort = 'asc' means oldest first
		## sort = 'desc' means most recent first
	
		# Get a list of 'Normal' Transactions By Address

		# [Optional Parameters] startblock: starting blockNo to retrieve results, endblock: ending blockNo to retrieve results

		# http://api.etherscan.io/api?
		# module=account
		# &action=txlist
		# &address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a
		# &startblock=0
		# &endblock=99999999
		# &sort=asc
		# &apikey=YourApiKeyToken
		
		# ([BETA] Returned 'isError' values: 0=No Error, 1=Got Error)
		# (Returns up to a maximum of the last 10000 transactions only)

		# or

		# https://api.etherscan.io/api?
		# module=account
		# &action=txlist
		# &address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a
		# &startblock=0
		# &endblock=99999999
		# &page=1
		# &offset=10
		# &sort=asc
		# &apikey=YourApiKeyToken
		
		# WE HANDLE THE FIRST CASE
		
		# output

		# {
		#	:blockNumber=>"4129371",
		#	:timeStamp=>"1502136746",
		#	:hash=>"0x512f5267d7a4835a80aed90305aa0d1129376e9a18ec539591e0b4d7c78296bd",
		#	:nonce=>"18136",
		#	:blockHash=>"0xc0d650977ff17fd0ab66e243b21e41936d5bdd61dc36e4d84e939630f2d7383f",
		#	:transactionIndex=>"34",
		#	:from=>"0x29d5527caa78f1946a409fa6acaf14a0a4a0274b",
		#	:to=>"0x97f30f0874120ff847ef6b2be5dddf3252654afd",
		#	:value=>"1100000000000000000",
		#	:gas=>"42000",
		#	:gasPrice=>"21000000000",
		#	:isError=>"0",
		#	:input=>"0x",
		#	:contractAddress=>"",
		#	:cumulativeGasUsed=>"1058935",
		#	:gasUsed=>"21000",
		#	:confirmations=>"9801"
		# }
		
		h = {
			:module => 'account',
			:action => 'txlist',
			:address => address,
			:startblock => startblock,
			:endblock => endblock,
			:sort => sort
		}	

		res = submit_query(h)
		
	end

	# =========================================================================
	
	def get_internal_transactions(address, sort='asc', startblock=0, endblock=99999999)

		# [BETA] Get a list of 'Internal' Transactions by Address

		#[Optional Parameters] startblock: starting blockNo to retrieve results, endblock: ending blockNo to retrieve results


		# http://api.etherscan.io/api?
		# module=account
		# &action=txlistinternal
		# &address=0x2c1ba59d6f58433fb1eaee7d20b26ed83bda51a3
		# &startblock=0
		# &endblock=2702578
		# &sort=asc
		# &apikey=YourApiKeyToken

		# (Returned 'isError' values: 0=No Error, 1=Got Error)
		# (Returns up to a maximum of the last 10000 transactions only)

		# or

		# https://api.etherscan.io/api?
		# module=account
		# &action=txlistinternal
		# &address=0x2c1ba59d6f58433fb1eaee7d20b26ed83bda51a3&startblock=0
		# &endblock=2702578
		# &page=1
		# &offset=10
		# &sort=asc
		# &apikey=YourApiKeyToken
		
		# (To get paginated results use page=<page number> and offset=<max records to return>)

		h = {
			:module => 'account',
			:action => 'txlistinternal',
			:address => address,
			:startblock => startblock,
			:endblock => endblock,
			:sort => sort
		}	

		res = submit_query(h)

	end

	# =========================================================================
	
	def get_internal_transactions_hash(txhash)

		# Get "Internal Transactions" by Transaction Hash
		
		# https://api.etherscan.io/api?
		# module=account
		# &action=txlistinternal
		# &txhash=0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170
		# &apikey=YourApiKeyToken

		# (Returned 'isError' values: 0=Ok, 1=Rejected/Cancelled)

		# (Returns up to a maximum of the last 10000 transactions only)


		h = {
			:module => 'account',
			:action => 'txlistinternal',
			:txhash => txhash,

		}	

		res = submit_query(h)

	end
	
	###########################################################################
	#
	# Contracts
	#
	###########################################################################
	
	def get_contract_abi(address)
	
		# Get Contract ABI for Verified Contract Source Codes

		# https://api.etherscan.io/api?
		# module=contract
		# &action=getabi
		# &address=0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413
		# &apikey=YourApiKeyToken	

		h = {
			:module => 'contract',
			:action => 'getabi',
			:address => address
		}	

		res = submit_query(h)
		res[:result]
		
	end

	###########################################################################
	#
	# Transactions
	#
	###########################################################################
	
	###########################################################################
	#
	# Blocks
	#
	###########################################################################

	###########################################################################
	#
	# Event Logs
	#
	###########################################################################	

	def get_eventlog(contractaddress, topics, fromBlock=0, toBlock='latest')
	
		# https://api.etherscan.io/api?
		# module=logs
		# &action=getLogs
		# &fromBlock=379224
		# &toBlock=latest
		# &address=0x33990122638b9132ca29c723bdf037f1a891a70c
		# &topic0=0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545
		# &apikey=YourApiKeyToken	
	
		h = {
			:module => 'logs',
			:action => 'getlogs',
			:fromBlock => fromBlock,
			:toBlock => toBlock,
			:address => contractaddress
		}	

		topics.keys.each do |t|
			h[t] = topics[t]
		end

		res = submit_query(h)
		
	end
	
	###########################################################################
	#
	# Geth/Parity Proxy APIs
	#
	###########################################################################	

	def get_eth_blockNumber
		
		# Returns the number of most recent block

		# https://api.etherscan.io/api?
		# module=proxy
		# &action=eth_blockNumber
		# &apikey=YourApiKeyToken
	
		h = {
			:module => 'proxy',
			:action => 'eth_blockNumber',
		}	

		res = submit_query(h)
		res[:result].to_i(16)
	
	end
  
  def get_eth_getTransactionByHash(tx_hash)
  
    # Returns the information about a transaction requested by transaction hash
    
    # https://api.etherscan.io/api?
    # module=proxy
    # &action=eth_getTransactionByHash
    # &txhash=0x1e2910a262b1008d0616a0beb24c1a491d78771baa54a33e66065e03b1f46bc1
    # &apikey=YourApiKeyToken
    
    h = {
			:module => 'proxy',
			:action => 'eth_getTransactionByHash',
      :txhash => tx_hash,
		}	

		res = submit_query(h)

  end

  def get_eth_getTransactionReceipt(tx_hash)
  
    # Returns the receipt of a transaction by transaction hash
    
    # https://api.etherscan.io/api?
    # module=proxy
    # &action=eth_getTransactionReceipt
    # &txhash=0x022c1bfb9b797eb22fa50f211ee28d193b9420280396c1e48b0923591ca33d70
    # &apikey=YourApiKeyToken
    
    h = {
			:module => 'proxy',
			:action => 'eth_getTransactionReceipt',
      :txhash => tx_hash,
		}	

		res = submit_query(h)

  end
  
	
	###########################################################################
	#
	# Websockets
	#
	###########################################################################	

	###########################################################################
	#
	# Token Info
	#
	###########################################################################	

	def get_token_total_supply(address, decimals)
	
		# Get ERC20-Token TotalSupply by ContractAddress

		# https://api.etherscan.io/api?
		# module=stats
		# &action=tokensupply
		# &contractaddress=0x57d90b64a1a57749b0f932f1a3395792e12e7055
		# &apikey=YourApiKeyToken

		h = {
			:module => 'stats',
			:action => 'tokensupply',
			:contractaddress => address
		}	

		res = submit_query(h)
		res[:result].to_f/10**decimals
		
	end	
	
	# =========================================================================
	
	def get_token_balance(contractaddress, address, decimals)
	
		# Get ERC20-Token Account Balance for TokenContractAddress 
		
		# https://api.etherscan.io/api?
		# module=account
		# &action=tokenbalance
		# &contractaddress=0x57d90b64a1a57749b0f932f1a3395792e12e7055
		# &address=0xe04f27eb70e025b78871a2ad7eabe85e61212761
		# &tag=latest
		# &apikey=YourApiKeyToken

		h = {
			:module => 'account',
			:action => 'tokenbalance',
			:contractaddress => contractaddress,
			:address => address,
			:tag => 'latest'
		}	

		res = submit_query(h)
		res[:result].to_f/10**decimals
		
	end	
	
	###########################################################################
	#
	# General Stats
	#
	###########################################################################	

	def get_eth_stats()

		# Get ETHER LastPrice Price

		# https://api.etherscan.io/api?
		# module=stats
		# &action=ethprice
		# &apikey=YourApiKeyToken
	
		# sample return value:
		# {
		#	:ethbtc=>0.08244,
		#	:ethbtc_timestamp=>2017-08-12 12:19:26 UTC,
		#	:ethusd=>312.5,
		#	:ethusd_timestamp=>2017-08-12 12:19:27 UTC
		# }

		h = {
			:module => 'stats',
			:action => 'ethprice'
		}	

		r = submit_query(h)[:result]
		
		r[:ethbtc] = r[:ethbtc].to_f
		r[:ethbtc_timestamp] = Time.at(r[:ethbtc_timestamp].to_i).utc
		r[:ethusd] = r[:ethusd].to_f
		r[:ethusd_timestamp] = Time.at(r[:ethusd_timestamp].to_i).utc
		
		r

	end

	def get_ethbtc()

		h = {
			:module => 'stats',
			:action => 'ethprice'
		}	

		r = submit_query(h)[:result]
		r[:ethbtc].to_f

	end

	def get_ethusd()

		h = {
			:module => 'stats',
			:action => 'ethprice'
		}	

		r = submit_query(h)[:result]
		r[:ethusd].to_f

	end
	
end
