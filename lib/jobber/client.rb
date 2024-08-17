# lib/jobber/client.rb

require_relative 'base'

module Jobber
  class Client < Base
    def fetch_customers
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
      }
      response = post_query(query)
      JSON.parse(response.body)
    end
  end
end
