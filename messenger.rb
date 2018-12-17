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
    items.select{|item| Time.parse(item.dig("start", "date")).today? }.map{|item| item.dig("summary")}
  end
end
