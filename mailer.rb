require 'dotenv/load'
require 'httparty'

class Mailer
  def initialize(to:, from:, subject:, body:)
    @to = to
    @from = from
    @subject = subject
    @body = body
  end

  def deliver
    api_key = ENV.fetch('MAILGUN_API_KEY')
    domain = ENV.fetch('MAILGUN_DOMAIN')
    url = mailgun_url(api_key: api_key, domain: domain)

    response = HTTParty.post url, body: {
      from: @from,
      to: @to,
      subject: @subject,
      text: @body
    }

    if response.code != 200
      raise "Mail did not enqueue successfully. #{response.inspect}"
    end

    # TODO(chaserx): maybe add some logging
    response
  end

  private

  def mailgun_url(api_key:, domain:)
    "https://api:#{api_key}@api.mailgun.net/v3/#{domain}/messages"
  end
end
