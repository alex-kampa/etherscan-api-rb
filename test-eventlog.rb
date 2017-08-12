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

res = e.get_eventlog(contractaddress, topics, 4000000, 'latest')

sl.p
sl.p 'Result: ' + res.inspect
sl.p

res[:result].each do |h|
	
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
	:topic2 => '0x00000000000000000000000040D50fC288BC5488813c17e7f403CA9BbE7914aD'
}

res = e.get_eventlog(contractaddress, topics, 3000000, 'latest')

sl.p
sl.p 'Result: ' + res.inspect
sl.p

res[:result].each do |h|
	
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

