# lib/jobber/customer.rb

require_relative 'base'

# Define a query to fetch customer details
CustomerQuery = <<-'GRAPHQL'
  query {
    customers(first: 1) {
      edges {
        node {
          id
          name
          email
        }
      }
    }
  }
GRAPHQL

# Method to fetch and print customer details
def fetch_and_print_customers
  begin
    response = Client.execute(GraphQL.parse(CustomerQuery))

    # Print the raw response for debugging
    puts "Raw response: #{response.inspect}"

    if response['data'] && response['data']['customers'] && response['data']['customers']['edges'].any?
      customer = response['data']['customers']['edges'].first['node']
      puts "Customer ID: #{customer['id']}"
      puts "Customer Name: #{customer['name']}"
      puts "Customer Email: #{customer['email']}"
    else
      puts "No customers found."
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
end
