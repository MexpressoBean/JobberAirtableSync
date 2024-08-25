# frozen_string_literal: true

require 'httparty'

# Load environment variables from .env file
Dotenv.load

# This class provides methods for interacting with the Airtable API.
# It supports fetching table schemas and making generic API requests.
class AirtableAPI
  include HTTParty
  base_uri 'https://api.airtable.com/v0'

  def initialize(base_key, table_name)
    @base_key = base_key
    @table_name = table_name
    @api_key = ENV['AIRTABLE_API_KEY']
  end

  def fetch_all_fields
    options = {
      headers: {
        'Authorization' => "Bearer #{@api_key}"
      }
    }

    response = self.class.get("/meta/bases/#{@base_key}/tables", options)
    raise "Failed to fetch schema: #{response.message}" unless response.success?

    tables = response['tables']
    table = tables.find { |t| t['name'] == @table_name }
    fields = table['fields'].map { |field| field['name'] }
    puts "Fields in #{@table_name}: #{fields.join(', ')}"
    fields
  end
end
