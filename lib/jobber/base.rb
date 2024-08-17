# lib/jobber/base.rb

require 'httparty'
require 'dotenv'

Dotenv.load

module Jobber
  class Base
    include HTTParty
    base_uri 'https://api.getjobber.com/api/graphql'

    def self.set_headers(access_token)
      headers(
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
        "X-JOBBER-GRAPHQL-VERSION" => "#{ENV['JOBBER_GRAPHQL_API_VERSION']}"
      )
    end

    def initialize(access_token = nil)
      self.class.set_headers(access_token) if access_token
    end

    def post_query(query)
      self.class.post("", body: query.to_json)
    end
  end
end
