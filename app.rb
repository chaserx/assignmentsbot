require 'json'
require 'messenger'

def lambda_handler(event:, context:)
  Messenger.new.outgoing
end
