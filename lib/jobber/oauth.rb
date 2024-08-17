# lib/jobber/oauth.rb

require 'httparty'
require 'dotenv'
require 'securerandom'
require 'uri'

Dotenv.load

module Jobber
  class OAuth
    AUTHORIZATION_URL = "https://api.getjobber.com/api/oauth/authorize"
    TOKEN_URL = "https://api.getjobber.com/api/oauth/token"
    CLIENT_ID = ENV['JOBBER_CLIENT_ID']
    CLIENT_SECRET = ENV['JOBBER_CLIENT_SECRET']
    REDIRECT_URI = ENV['JOBBER_REDIRECT_URI']

    attr_reader :state

    def initialize
      @state = SecureRandom.hex(16) # Generate a random state string for security
    end

    def authorization_url
      URI::HTTPS.build(
        host: 'api.getjobber.com',
        path: '/api/oauth/authorize',
        query: URI.encode_www_form({
          response_type: 'code',
          client_id: CLIENT_ID,
          redirect_uri: REDIRECT_URI,
          state: @state
        })
      ).to_s
    end

    def exchange_code_for_token(authorization_code)
      response = HTTParty.post(
        TOKEN_URL,
        body: {
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          grant_type: 'authorization_code',
          code: authorization_code,
          redirect_uri: REDIRECT_URI
        },
        headers: {
          "Content-Type" => "application/x-www-form-urlencoded"
        }
      )
      JSON.parse(response.body)
    end
  end
end
