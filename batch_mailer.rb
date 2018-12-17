require 'dotenv/load'
require 'mailgun-ruby'

class BatchMailer
  def initialize(recipient_list:, from:, subject:, text:)
    @recipient_list = recipient_list
    @from = from
    @subject = subject
    @text = text
  end

  def deliver_batch
    api_key = ENV.fetch('MAILGUN_API_KEY')
    domain = ENV.fetch('MAILGUN_DOMAIN')

    mg_client = Mailgun::Client.new(api_key)
    batch_message = Mailgun::BatchMessage.new(mg_client, domain)

    batch_message.from(@from)
    batch_message.subject(@subject)
    batch_message.body_text(@text)

    @recipient_list.each do |recipient|
      batch_message.add_recipient(:to, recipient)
    end

    batch_message.finalize
  end
end
