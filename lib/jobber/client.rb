# frozen_string_literal: true

require_relative 'base'

module Jobber
  # Jobber::Client is a class responsible for interacting with the Jobber API at a higher level.
  # Inheriting from Jobber::Base, this class provides specific methods for interacting with 
  # various Jobber resources, such as customers, jobs, and other entities.
  # It leverages the base functionality provided by Jobber::Base to perform GraphQL queries 
  # and handle API responses, simplifying the process of working with Jobber's API.
  # Use this class to perform specific client actions and fetch data from Jobber.  
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
