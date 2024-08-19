# frozen_string_literal: true

require 'httparty'
require 'dotenv'
require 'securerandom'
require 'uri'
require 'json'

Dotenv.load

module Jobber
  # Jobber::OAuth is responsible for handling the OAuth authentication process with the Jobber API.
  # This class manages the flow of obtaining and refreshing OAuth tokens, ensuring that API requests 
  # are properly authenticated. It handles the authorization code exchange, token storage, 
  # and token refresh logic as required by the Jobber OAuth protocol.
  # Use this class to securely authenticate and maintain authorized access to the Jobber API.
  class OAuth
    AUTHORIZATION_URL = 'https://api.getjobber.com/api/oauth/authorize'
    TOKEN_URL = 'https://api.getjobber.com/api/oauth/token'
    CLIENT_ID = ENV['JOBBER_CLIENT_ID']
    CLIENT_SECRET = ENV['JOBBER_CLIENT_SECRET']
    REDIRECT_URI = ENV['JOBBER_REDIRECT_URI']

    attr_reader :state

    def initialize
      @state = SecureRandom.hex(16)
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
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      )
      JSON.parse(response.body)
    end
  end
end
