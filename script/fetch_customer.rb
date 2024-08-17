require_relative '../lib/jobber/client'
require_relative '../lib/airtable/customer'

# Fetch the first customer record
# customers = AirtableCustomer.all

# customers.each do |record|
#     puts "#{record.id}: #{record["Customer Name"]}"
# end
# require "byebug";byebug
# puts customers.first



# Fetch and print customers from Jobber
jobber_client = Jobber::Client.new
jobber_data = jobber_client.fetch_customers

puts "Jobber Customers:"
# jobber_data["data"]["clients"]["nodes"].each do |customer|
#   puts "ID: #{customer['id']}, Name: #{customer['firstName']} #{customer['lastName']}, City: #{customer['billingAddress']['city']}"
# end
puts jobber_data

