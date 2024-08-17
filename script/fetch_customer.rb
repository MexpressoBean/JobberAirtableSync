require_relative '../lib/jobber/client'
require_relative '../lib/jobber/auth_manager'
require_relative '../lib/airtable/customer'

# Fetch the first customer record
# customers = AirtableCustomer.all

# customers.each do |record|
#     puts "#{record.id}: #{record["Customer Name"]}"
# end
# require "byebug";byebug
# puts customers.first


# Initialize AuthManager and ensure we have an access token
auth_manager = Jobber::AuthManager.new
access_token = auth_manager.ensure_access_token

# Fetch and print customers from Jobber
jobber_client = Jobber::Client.new(access_token)
jobber_data = jobber_client.fetch_customers

puts "Jobber Customers:"
jobber_data["data"]["clients"]["nodes"].each do |customer|
  puts "ID: #{customer['id']}, Name: #{customer['firstName']} #{customer['lastName']}"
end
puts "TOTAL CUSTOMERS: #{jobber_data["data"]["clients"]["totalCount"]}"
# puts jobber_data

#######################
# Both airtable and jobber api integrations are
# working to pull data from my accounts!

# Next step is to further automate grabbing the access code 
# from the browser when we authenticate through jobber.
# Currently there is a manual step of visiting the auth url 
# and grabbing the code from the query params.

# After that, we can begin the logic for the sync between jobber and airtable.
# Start by syncing customers first.  Then branch out from there.
#######################