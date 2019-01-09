require 'json'
require_relative '../person'

# NOTE(chaserx): This method is directly called directly by Lambda on invocation
def create(event:, context:)
  body = JSON.parse(event["body"])
  if body["verbose"] == true
    response(body: event)
  else
    response(body: body)
  end
end

def create_person(json_payload)
  # person = Person.new

end

def params(json_payload)
  JSON.parse(json_payload)
end

def person_params
  whitelist = [:email_address, :teams]
  params.keep_if {|k,_| whitelist.include? k}
end

def permit(*filters)
  self.keep_if {|k,_| filters.include? k}
end

def response(statusCode: 200, body:)
  { statusCode: statusCode, body: JSON.generate(body) }
end
