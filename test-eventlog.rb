require 'json'
require 'rest-client'
require_relative "utils"
require_relative "EtherscanAPI"

api_key = File.file?('api.key') ? File.open('api.key').read : ''

sl = sl = SimpleLog.new({:verbose => true})
sl.p "\n\n----------{ running #{$0} - #{Time.now.utc} }----------\n\n"

e = EtherscanAPI.new(api_key, sl, {:print_query => true})


############################################################################### 
#
# Get event log for an address (all events after block 4000000)
#

sl.h1 'Eventlog for an address (all events after block 4000000)'

contractaddress = '0x4994e81897a920c0FEA235eb8CEdEEd3c6fFF697'

topics = {
	:topic0 => '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
}

res = e.get_eventlog_0(contractaddress, topics, 4000000, 'latest')

sl.p
sl.p 'Result: ' + res[:result].inspect
sl.p

res[:result].each do |h|
	
	# {:address=>"0x4994e81897a920c0fea235eb8cedeed3c6fff697",
	# :topics=>["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
	#		"0x0000000000000000000000001845304c7899c292583b12b417dd5d5919228ac0",
	#		"0x0000000000000000000000001d60606d8a09b5015d773a80b0c660bb8d91809c"],
	# :data=>"0x0000000000000000000000000000000000000000000001b45fff1e897f47324a",
	# :blockNumber=>"0x3d92d5",
	# :timeStamp=>"0x596cd748",
	# :gasPrice=>"0xdf8475800",
	# :gasUsed=>"0x9281",
	# :logIndex=>"0x",
	# :transactionHash=>"0xe09a1d5f1cb327e2c7c55c8c300a7f61fbfadce48e151d916b2f6adc6576679a",#
	# :transactionIndex=>"0x3"}
	
	from = '0x' + h[:topics][1].split(//).last(40).join
	to = '0x' + h[:topics][2].split(//).last(40).join
	block = h[:blockNumber].to_i(16)
	t = h[:timeStamp].to_i(16)
	t = Time.at(t).utc
	amount = h[:data].to_i(16)
	tx_hash = h[:transactionHash]
	
	sl.p
	sl.p "#{t} block #{block}"
	sl.p "Tx Hash: #{tx_hash}"
	sl.p "From: #{from}"
	sl.p "To: #{to}"
	sl.p "Amount: #{amount} (#{amount/1e18})"
	
end



############################################################################### 
#
# Get event log for an address (list only tokens received by a specific account since block 3000000)
#

sl.h1 'Eventlog for an address (list only tokens received by a specific account)'

contractaddress = '0x4994e81897a920c0FEA235eb8CEdEEd3c6fFF697'

topics = {
	:topic0 => '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
	:topic0_2_opr => 'and',
	:topic2 => '0x000000000000000000000000b4f14edd0e846727cae9a4b866854ed1bfe95781' 
}

res = e.get_eventlog_0(contractaddress, topics, 3000000, 'latest')

sl.p
sl.p 'Result: ' + res[:result].inspect
sl.p

res[:result].each do |h|
	
	# {:address=>"0x4994e81897a920c0fea235eb8cedeed3c6fff697",
	# :topics=>["0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
	#		"0x0000000000000000000000001845304c7899c292583b12b417dd5d5919228ac0",
	#		"0x0000000000000000000000001d60606d8a09b5015d773a80b0c660bb8d91809c"],
	# :data=>"0x0000000000000000000000000000000000000000000001b45fff1e897f47324a",
	# :blockNumber=>"0x3d92d5",
	# :timeStamp=>"0x596cd748",
	# :gasPrice=>"0xdf8475800",
	# :gasUsed=>"0x9281",
	# :logIndex=>"0x",
	# :transactionHash=>"0xe09a1d5f1cb327e2c7c55c8c300a7f61fbfadce48e151d916b2f6adc6576679a",#
	# :transactionIndex=>"0x3"}
	
	from = '0x' + h[:topics][1].split(//).last(40).join
	to = '0x' + h[:topics][2].split(//).last(40).join
	block = h[:blockNumber].to_i(16)
	t = h[:timeStamp].to_i(16)
	t = Time.at(t).utc
	amount = h[:data].to_i(16)
	tx_hash = h[:transactionHash]
	
	sl.p
	sl.p "#{t} block #{block}"
	sl.p "Tx Hash: #{tx_hash}"
	sl.p "From: #{from}"
	sl.p "To: #{to}"
	sl.p "Amount: #{amount} (#{amount/1e18})"
	
end
	

############################################################################### 
#
# write to log and exit
#

write_to_file(sl.sLog, 'sLog.log', 'a')

