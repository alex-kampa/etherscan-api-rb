require 'json'
require 'rest-client'
require_relative "utils"
require_relative "EtherscanAPI"

api_key = File.file?('api.key') ? File.open('api.key').read : ''

sl = sl = SimpleLog.new({:verbose => true})
sl.p "\n\n----------{ running #{$0} - #{Time.now.utc} }----------\n\n"

e = EtherscanAPI.new(api_key, sl)


############################################################################### 
#
# ETH price
#

sl.h1 'ETH price'

sl.h2 'get_eth_stats()'
e.print_next_query
res = e.get_eth_stats()
sl.p 'result: ' + res.inspect
	
sl.h2 'get_ethbtc()'
res = e.get_ethbtc()
sl.p 'result: ' + res.inspect

sl.h2 'get_ethusd()'
res = e.get_ethusd()
sl.p 'result: ' + res.inspect


############################################################################### 
#
# write to log and exit
#

write_to_file(sl.sLog, 'sLog.log', 'a')

