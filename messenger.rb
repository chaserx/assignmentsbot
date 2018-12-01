require 'json'
require_relative 'calendar'
require_relative 'template'

def outgoing
  puts "this will eventually send email out"
  # response = Calendar.get
end

def studies_message(response)
  calendar_data = JSON.parse(response.body)

  Template.new(summary: calendar_data.dig('summary'), assignments: assignments(calendar_data)).to_s
end

def assignments(hsh)
  items = hsh.dig("items") || [{}]
  items.map{|item| item.dig("summary")}
end
