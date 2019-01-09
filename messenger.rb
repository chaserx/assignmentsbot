require 'date'
require 'json'
require 'active_support/all'
require_relative 'calendar'
require_relative 'template'
require_relative 'batch_mailer'

class Messenger
  def outgoing(calendar_data:, recipient_list:)
    message = studies_message(calendar_data)
    mailer = BatchMailer.new(recipient_list: recipient_list,
                        from: "no-reply@assignmentsbot.com",
                        subject: "#{calendar_summary(calendar_data)} Assignments for #{Date.today.to_s}",
                        text: message)
    mailer.deliver_batch
  end

  private

  def calendar_summary(calendar_data)
    calendar_data.dig('summary')
  end

  def studies_message(calendar_data)
    Template.new(summary: calendar_summary(calendar_data), assignments: assignments(calendar_data)).output
  end

  def assignments(hsh)
    items = hsh.dig("items") || [{}]
    items.select{|item| Time.parse(start_date_or_datetime(item)).today? }.map{|item| item.dig("summary")}
  end

  # NOTE(chaserx): adding this method as there appears to be two ways of including an event
  def start_date_or_datetime(event)
    case event.dig("start")&.keys
    when ["date"]
      event.dig("start", "date")
    when ["dateTime"]
      event.dig("start", "dateTime")
    else
      # NOTE(chaserx): I'm not sure this is a sensible default.
      #    It certainly fails the .today? check
      #    and it's a valid string for Time.parse instead of nil or empty string
      "January 1, 1970"
    end
  end
end
