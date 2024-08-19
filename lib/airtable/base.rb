require 'airrecord'
require 'dotenv'

# Load environment variables from .env file
Dotenv.load

# Configure the Airrecord API key using the environment variable
Airrecord.api_key = ENV['AIRTABLE_API_KEY']
