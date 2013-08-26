require 'faraday'
require_relative 'version'

module TeamCity
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :endpoint,
      :user_agent,
      :http_user,
      :http_password
    ].freeze

    DEFAULT_ADAPTER = Faraday.default_adapter

    DEFAULT_ENDPOINT = 'http://teamcity:8111/httpAuth/app/rest/'.freeze

    DEFAULT_USER_AGENT = "TeamCity Ruby Client #{TeamCity::VERSION}".freeze

    DEFAULT_HTTP_USER = nil

    DEFAULT_HTTP_PASSWORD = nil

    DEFAULT_FORMAT = :json

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.endpoint       = DEFAULT_ENDPOINT
      self.user_agent     = DEFAULT_USER_AGENT
      self.http_user      = DEFAULT_HTTP_USER
      self.http_password  = DEFAULT_HTTP_PASSWORD
    end
  end
end