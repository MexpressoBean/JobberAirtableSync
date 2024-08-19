# frozen_string_literal: true

require_relative 'base'

# AirtableCustomerTable interacts with the Airtable API to manage customer (table within airtable) data.
# This class uses the Airrecord gem to map the Airtable table to a Ruby object.
class AirtableCustomerTable < Airrecord::Table
  self.base_key = ENV['AIRTABLE_CUSTOMER_BASE_ID']
  self.table_name = 'Customers'

  # Define methods for easier access to columns
  def customer_name
    self['Customer Name']
  end

  def email
    self['Email']
  end
end
