require_relative '../lib/airtable/customer'
require_relative '../lib/jobber/customer'

# Fetch the first customer record
# customers = AirtableCustomer.all

# customers.each do |record|
#     puts "#{record.id}: #{record["Customer Name"]}"
# end
# require "byebug";byebug
# puts customers.first



require 'httparty'
require 'dotenv'
require 'json'

# Load environment variables from .env file
Dotenv.load

# Define the GraphQL query
query = {
  query: <<-GRAPHQL
    query SampleQuery {
      clients {
        nodes {
          id
          firstName
          lastName
          billingAddress {
            city
          }
        }
        totalCount
      }
    }
  GRAPHQL
}.to_json

# Make the POST request to the Jobber API
response = HTTParty.post(
  "https://api.getjobber.com/api/graphql",
  body: query,
  headers: {
    "Authorization" => "Bearer #{ENV['JOBBER_API_TOKEN']}",
    "Content-Type" => "application/json",
    "X-JOBBER-GRAPHQL-VERSION" => "#{ENV['JOBBER_GRAPHQL_API_VERSION']}"
  }
)

# Parse and print the response
result = JSON.parse(response.body)
puts "Response: #{result.inspect}"
