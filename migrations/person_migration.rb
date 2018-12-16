require 'aws-record'
require_relative '../person'

class PersonMigration
  include Aws::Record

  def self.up
    cfg = TableConfig.define do |t|
      t.model_class(Person)
      t.read_capacity_units(1)
      t.write_capacity_units(1)

      t.global_secondary_index(:confirmation_token_index) do |i|
        i.read_capacity_units 1
        i.write_capacity_units 1
      end
    end
    cfg.migrate!
  end
end

PersonMigration.up
