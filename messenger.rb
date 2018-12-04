require 'json'
require_relative 'calendar'
require_relative 'template'

class Messenger
  def outgoing
    response = Calendar.get
    if response.code != 200
      raise 'failed to get a successful response from google calendar'
    end

    studies_message(response)
  end

  private

  def studies_message(response)
    calendar_data = JSON.parse(response.body)

    Template.new(summary: calendar_data.dig('summary'), assignments: assignments(calendar_data)).to_s
  end

  def assignments(hsh)
    items = hsh.dig("items") || [{}]
    items.map{|item| item.dig("summary")}
  end
end
