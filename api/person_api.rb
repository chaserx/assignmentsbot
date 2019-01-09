require 'json'
require_relative '../person'

def create(event:, context:)
  body = JSON.parse(event["body"])
  if body["verbose"] == true
    response(body: event)
  else
    response(body: body)
  end
end

def response(statusCode: 200, body:)
  { statusCode: statusCode, body: JSON.generate(body) }
end
