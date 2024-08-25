# frozen_string_literal: true

require 'httparty'
require 'dotenv'

Dotenv.load

module Jobber
  # Jobber::Base serves as the base class for interacting with the Jobber API.
  # It provides the foundational methods for making GraphQL requests to the Jobber API endpoint.
  # This class sets up the necessary headers, including authorization and content type,
  # and offers a method (`post_query`) to send GraphQL queries.
  # Other classes within the Jobber module can inherit from this class to perform specific API actions.
  # This class uses the HTTParty gem for handling HTTP requests.
  class Base
    include HTTParty
    base_uri 'https://api.getjobber.com/api/graphql'

    def self.set_headers(access_token)
      headers(
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json',
        'X-JOBBER-GRAPHQL-VERSION' => (ENV['JOBBER_GRAPHQL_API_VERSION']).to_s
      )
    end

    def initialize(access_token = nil)
      self.class.set_headers(access_token) if access_token
    end

    def post_query(query)
      self.class.post('', body: query.to_json)
    end
  end
end
