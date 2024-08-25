# frozen_string_literal: true

require_relative 'airtable_api_client'
require 'airrecord'
require 'dotenv'
require 'json'

JOBBER_BASE_SCHEMA_PATH = 'lib\airtable\schemas\jobber_base_schema.json'
# Load environment variables from .env file
Dotenv.load

# Base class for all your Airtable tables
class BaseAirtableTable < Airrecord::Table
  Airrecord.api_key = ENV['AIRTABLE_API_KEY']

  # Class method to load and store the schema from a JSON file
  def self.load_schema(file_path)
    @schema ||= JSON.parse(File.read(file_path))
  end

  # Ensure the table has all desired fields based on the loaded schema
  def self.ensure_fields_exist
    # Load the schema if it's not already loaded
    load_schema(JOBBER_BASE_SCHEMA_PATH) unless @schema
    raise 'Schema not loaded. Ensure the JSON schema file is correctly formatted.' unless @schema

    # Retrieve the desired fields from the schema
    table_name = self.table_name
    desired_fields = @schema[table_name]['fields']

    # Inspect existing fields via Airtable Meta API
    airtable_client = AirtableAPI.new(ENV['AIRTABLE_CUSTOMER_BASE_ID'], table_name)

    # Fetch fields
    existing_fields = airtable_client.fetch_all_fields

    # Find missing fields
    missing_fields = desired_fields - existing_fields

    if missing_fields.empty?
      puts "All desired fields are present for #{table_name}."
    else
      puts "Missing fields in #{table_name}: #{missing_fields.join(', ')}"
      # Handle missing fields as needed (e.g., notify, log, or raise an error)
    end
  end
end
