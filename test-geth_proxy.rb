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
# ERC20 token balance
#

sl.h2 'Latest block'

res = e.get_eth_blockNumber()
sl.p 'result: ' + res.inspect


############################################################################### 
#
# write to log and exit
#

write_to_file(sl.sLog, 'sLog.log', 'a')

