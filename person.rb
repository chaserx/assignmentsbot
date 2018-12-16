require 'aws-record'
require 'dotenv/load'
require 'securerandom'
require 'time'

class Person
  include Aws::Record

  if ENV.fetch('LOCAL_ONLY')
    Aws.config.update({
      profile: 'chaserx'
    })
  end

  set_table_name ENV.fetch('DYNAMO_TABLE_NAME')
  string_attr :email_address, hash_key: true
  string_attr :confirmation_token, default_value: SecureRandom.hex(3)
  string_set_attr :teams # ['voyagers6', 'explorers6', 'navigators6']
  boolean_attr :accepted_tos, default_value: false
  boolean_attr :confirmed, default_value: false
  datetime_attr :created_at, default_value: Time.now.iso8601

  global_secondary_index(
    :confirmation_token_index,
    hash_key:  :confirmation_token,
    projection: {
      projection_type: "ALL"
    }
  )

  def self.find(email_address)
    if email_address
      begin
        query_params = {
          table_name: table_name,
          expression_attribute_names: {
            '#hash_key_name' => 'email_address'
          },
          expression_attribute_values: {
            ':hash_key_val' => email_address
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

  def self.find_by_confirmation_status(status)
    if status
      begin
        query_params = {
          table_name: table_name,
          expression_attribute_names: {
            '#hash_key_name' => 'confirmed'
          },
          expression_attribute_values: {
            ':hash_key_val' => status
          },
          filter_expression: '#hash_key_name = :hash_key_val'
        }
        self.scan(query_params)
      rescue Aws::DynamoDB::Errors::ServiceError => e
        puts e.message
        nil
      end
    else
      nil # TODO(chaserx): probably should return an error rather than nil
    end
  end

  # this should return a single person by their confirmation token.
  #   it requires a secondary index on confirmation token
  def self.find_by_confirmation_token(token)
    if token
      begin
        query_params = {
          table_name: table_name,
          index_name: 'confirmation_token_index',
          expression_attribute_names: {
            '#hash_key_name' => 'confirmation_token'
          },
          expression_attribute_values: {
            ':hash_key_val' => token
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

  def self.find_by_team(team_name)
    if team_name
      begin
        query_params = {
          table_name: table_name,
          expression_attribute_names: {
            '#hash_key_name' => 'teams'
          },
          expression_attribute_values: {
            ':hash_key_val' => team_name
          },
          filter_expression: 'contains(#hash_key_name, :hash_key_val)'
        }
        self.scan(query_params)
      rescue Aws::DynamoDB::Errors::ServiceError => e
        puts e.message
        nil
      end
    else
      nil # TODO(chaserx): probably should return an error rather than nil
    end
  end

  def self.find_confirmed_by_team(team_name)
    if team_name
      begin
        query_params = {
          table_name: table_name,
          expression_attribute_names: {
            '#hash_team_name' => 'teams',
            '#confirmed_key' => 'confirmed'
          },
          expression_attribute_values: {
            ':hash_team_val' => team_name,
            ':confirmed_val' => true
          },
          filter_expression: 'contains(#hash_team_name, :hash_team_val) AND #confirmed_key = :confirmed_val'
        }
        self.scan(query_params)
      rescue Aws::DynamoDB::Errors::ServiceError => e
        puts e.message
        nil
      end
    else
      nil # TODO(chaserx): probably should return an error rather than nil
    end
  end
end
