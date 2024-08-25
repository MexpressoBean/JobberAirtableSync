# frozen_string_literal: true

require_relative 'oauth'
require_relative 'client'
require 'json'

module Jobber
  # Jobber::AuthManager is responsible for managing the authentication flow with the Jobber API.
  # It handles obtaining, storing, and refreshing the access token needed for API requests.
  # The access token is saved to a JSON file (`token.json`) for persistence across sessions.
  # This class ensures that API requests are authorized by handling the token lifecycle.
  class AuthManager
    TOKEN_FILE = 'token.json'

    def initialize
      @oauth_client = OAuth.new
    end

    def ensure_access_token
      token_data = read_token
      access_token = token_data['access_token']

      if access_token.nil? || !valid_access_token?(access_token)
        puts 'Access token is invalid or missing.'
        puts 'Please go to the following URL to authorize the application:'
        puts @oauth_client.authorization_url
        puts 'Once you have authorized the application, enter the code from the URL below:'
        authorization_code = gets.chomp

        # Exchange authorization code for an access token
        token_data = @oauth_client.exchange_code_for_token(authorization_code)

        if token_data['access_token']
          write_token(token_data)
          access_token = token_data['access_token']
          puts 'Access token retrieved and stored successfully.'
        else
          puts "Failed to retrieve access token: #{token_data}"
          exit
        end
      end

      access_token
    end

    private

    def valid_access_token?(access_token)
      client = Jobber::Client.new(access_token)
      # Making a simple request to check if the token is valid
      response = client.fetch_customers

      # Check if the response contains an error message related to the token
      if response.is_a?(Hash) && (response['message'] == 'Token not recognized' || response['message'] == 'Access token expired')
        puts 'Invalid access token detected.'
        false
      else
        true # Token is valid if there is no error message
      end
    rescue StandardError => e
      puts "Error validating access token: #{e.message}"
      false
    end

    def read_token
      return {} unless File.exist?(TOKEN_FILE)

      JSON.parse(File.read(TOKEN_FILE))
    end

    def write_token(token_data)
      File.open(TOKEN_FILE, 'w') do |file|
        file.write(token_data.to_json)
      end
    end
  end
end
