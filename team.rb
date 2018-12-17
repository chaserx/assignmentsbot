require 'aws-record'
require 'dotenv/load'
require 'securerandom'
require 'time'

class Team
  include Aws::Record

  if ENV.fetch('LOCAL_ONLY')
    Aws.config.update({
      profile: 'chaserx'
    })
  end

  set_table_name ENV.fetch('DDB_TEAM_TABLE')
  string_attr :name, hash_key: true
  string_attr :calendar_id
  datetime_attr :created_at, default_value: Time.now.iso8601

  def self.find(name)
    if name
      begin
        query_params = {
          table_name: table_name,
          expression_attribute_names: {
            '#hash_key_name' => 'name'
          },
          expression_attribute_values: {
            ':hash_key_val' => name
          },
          key_condition_expression: '#hash_key_name = :hash_key_val'
        }
        self.query(query_params)
      rescue Aws::DynamoDB::Errors::ServiceError => e
        puts e.message
        nil
      end
    else
      nil # TODO(chaserx): probably should return an error rather than nil
    end
  end

  def self.all
    self.scan
  rescue Aws::DynamoDB::Errors::ServiceError => e
    puts e.message
    nil
  end
end
