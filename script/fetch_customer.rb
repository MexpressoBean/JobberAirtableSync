require_relative '../lib/jobber/client'
require_relative '../lib/airtable/customer'
require_relative '../lib/jobber/oauth'

# Fetch the first customer record
# customers = AirtableCustomer.all

# customers.each do |record|
#     puts "#{record.id}: #{record["Customer Name"]}"
# end
# require "byebug";byebug
# puts customers.first


#############
# Initialize OAuth client
oauth_client = Jobber::OAuth.new

# Step 1: Read the access token from token.json
token_data = oauth_client.read_token
access_token = token_data['access_token']

if access_token.nil?
  puts "Please go to the following URL to authorize the application:"
  puts oauth_client.authorization_url
  puts "Once you have authorized the application, enter the code from the URL below:"
  authorization_code = gets.chomp

  # Step 2: Exchange authorization code for an access token
  token_data = oauth_client.exchange_code_for_token(authorization_code)

  if token_data['access_token']
    # Store the access token in token.json
    oauth_client.write_token(token_data)
    access_token = token_data['access_token']
    puts "Access token retrieved and stored successfully."
  else
    puts "Failed to retrieve access token: #{token_data}"
    exit
  end
end

# Update Client class to use the access token from token.json
Jobber::Base.class_eval do
  define_method(:initialize) do
    self.class.headers(
      "Authorization" => "Bearer #{access_token}",
      "Content-Type" => "application/json",
      "X-JOBBER-GRAPHQL-VERSION" => "#{ENV['JOBBER_GRAPHQL_API_VERSION']}"
    )
  end
end
#############

# Fetch and print customers from Jobber
jobber_client = Jobber::Client.new
jobber_data = jobber_client.fetch_customers

puts "Jobber Customers:"
# jobber_data["data"]["clients"]["nodes"].each do |customer|
#   puts "ID: #{customer['id']}, Name: #{customer['firstName']} #{customer['lastName']}, City: #{customer['billingAddress']['city']}"
# end
puts jobber_data

