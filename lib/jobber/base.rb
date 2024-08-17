# lib/jobber/base.rb

require 'httparty'
require 'dotenv'

Dotenv.load

module Jobber
  class Base
    include HTTParty
    base_uri 'https://api.getjobber.com/api/graphql'

    def initialize
      self.class.headers(
        "Authorization" => "Bearer #{ENV['JOBBER_ACCESS_TOKEN']}",
        "Content-Type" => "application/json",
        "X-JOBBER-GRAPHQL-VERSION" => "#{ENV['JOBBER_GRAPHQL_API_VERSION']}"
      )
    end

    def post_query(query)
      self.class.post("", body: query.to_json)
    end
  end
end