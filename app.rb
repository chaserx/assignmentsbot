require 'json'
require_relative 'messenger'

def lambda_handler(event:, context:)
  Messenger.new.outgoing
end
