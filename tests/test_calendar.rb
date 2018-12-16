require 'rubygems'
require 'test/unit'
require 'vcr'
require 'json'
require_relative '../calendar'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<APIKEY>") do
    ENV['API_KEY']
  end
end

class CalendarTest < Test::Unit::TestCase
  def test_calendar
    VCR.use_cassette("google_calendar") do
      response = Calendar.get('fayette.kyschools.us_jtcs0efrcacc9c8pk9e303278c%40group.calendar.google.com')
      assert_equal "Voyager Team Homework Calendar", JSON.parse(response.body)["summary"]
    end
  end
end
