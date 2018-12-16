require 'json'
require_relative 'messenger'
require_relative 'person'

def lambda_handler(event:, context:)

  [
    { calendar_id: 'fayette.kyschools.us_jtcs0efrcacc9c8pk9e303278c%40group.calendar.google.com', team: 'voyagers_6' }
  ].each do |entry|
    response = Calendar.get(entry[:calendar_id])
    if response.code != 200
      raise "Failed to get a successful response from Google Calendar. #{response.inspect}"
    end

    recipients = Person.find_confirmed_by_team(entry[:team]).entries.map(&:email_address)
    puts recipients.inspect

    Messenger.new.outgoing(calendar_data: JSON.parse(response), recipient_list: recipients)
  end

end
