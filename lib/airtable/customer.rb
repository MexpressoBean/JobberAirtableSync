require_relative 'base'

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
