require 'json'
require_relative 'messenger'
require_relative 'person'
require_relative 'team'

def lambda_handler(event:, context:)
  Team.all.each do |team|
    puts "Getting data for #{team.name} at #{team.calendar_id}"
    response = Calendar.get(team.calendar_id)
    if response.code != 200
      raise "Failed to get a successful response from Google Calendar. #{response.inspect}"
    end

    recipients = Person.find_confirmed_by_team(team.name).entries.map(&:email_address)
    puts recipients.inspect
    if recipients.any?
      Messenger.new.outgoing(calendar_data: JSON.parse(response.body), recipient_list: recipients)
    end
  end
end
