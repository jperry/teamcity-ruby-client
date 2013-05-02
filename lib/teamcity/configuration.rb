require 'faraday'
require_relative 'version'

module TeamCity
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :endpoint,
      :user_agent,
      :format,
      :http_user,
      :http_password
    ].freeze

    VALID_FORMATS = [:json].freeze

    DEFAULT_ADAPTER = Faraday.default_adapter

    DEFAULT_ENDPOINT = 'http://teamcity:8111/httpAuth/app/rest/7.0/'.freeze

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
      self.format         = DEFAULT_FORMAT
      self.http_user      = DEFAULT_HTTP_USER
      self.http_password  = DEFAULT_HTTP_PASSWORD
    end
  end
end