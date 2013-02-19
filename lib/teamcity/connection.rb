require 'faraday_middleware'

module TeamCity
  # @private
  module Connection
    private

    def connection
      options = {
        :headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
        :ssl => {:verify => false},
        :url => endpoint,
      }

      Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        case format.to_s.downcase
        when 'json' then connection.use Faraday::Response::ParseJson
        end
        connection.adapter(adapter)
      end
    end
  end
end