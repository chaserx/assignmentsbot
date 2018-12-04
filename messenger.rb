require 'date'
require 'json'
require_relative 'calendar'
require_relative 'template'
require_relative 'mailer'

class Messenger
  def outgoing
    response = Calendar.get
    if response.code != 200
      raise "Failed to get a successful response from Google Calendar. #{response.inspect}"
    end

    message = studies_message(response)
    mailer = Mailer.new(to: "chase.southard@gmail.com",
                        from: "no-reply@assignmentsbot.com",
                        subject: "Assignments for #{Date.today.to_s}",
                        text: message)
    mailer.deliver
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
