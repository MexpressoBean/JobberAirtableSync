require_relative '../lib/jobber/client'
require_relative '../lib/airtable/customer'
require_relative '../lib/jobber/auth_manager'

# Fetch the first customer record
# customers = AirtableCustomer.all

# customers.each do |record|
#     puts "#{record.id}: #{record["Customer Name"]}"
# end
# require "byebug";byebug
# puts customers.first


#############
auth_manager = Jobber::AuthManager.new
access_token = auth_manager.ensure_access_token

# Update Client class to use the access token
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
