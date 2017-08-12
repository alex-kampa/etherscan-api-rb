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

sl.h2 'ERC20 token balance'

contractaddress = '0x4994e81897a920c0FEA235eb8CEdEEd3c6fFF697'
acc = '0xB4f14EDd0e846727cAe9A4B866854ed1bfE95781'
decimals = 18

res = e.get_token_balance(contractaddress, acc, decimals)
sl.p 'result: ' + res.inspect


############################################################################### 
#
# write to log and exit
#

write_to_file(sl.sLog, 'sLog.log', 'a')

