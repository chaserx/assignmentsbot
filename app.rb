require 'json'
require 'messenger'

def lambda_handler(event:, context:)
  puts Messenger.new.outgoing
end
