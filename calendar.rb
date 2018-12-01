require 'dotenv/load'
require 'httparty'
require 'active_support/all'

class Calendar
  def self.get
    base_url = "https://www.googleapis.com/calendar/v3/calendars"
    calendar = ENV.fetch('CALENDAR')
    resource = "events"
    query = {
      "timeMin" => Date.current.midnight.rfc3339,
      "timeMax" => Date.tomorrow.midnight.rfc3339,
      "key" => ENV.fetch('API_KEY')
    }

    HTTParty.get([base_url, calendar, resource].join('/'), query: query)
  end
end
