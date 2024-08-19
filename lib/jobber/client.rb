# frozen_string_literal: true

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

# Next step, figure out how to organize my operations better here to pull fromjobber and airtable
