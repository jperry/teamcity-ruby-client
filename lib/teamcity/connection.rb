require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module TeamCity
  # @private
  module Connection
    private

    def connection
      options = {
        :headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
        :ssl => {:verify => false},
        :url => endpoint
      }

      Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        case format.to_s.downcase
        when 'json' then connection.use FaradayMiddleware::ParseJson
        end
        connection.use FaradayMiddleware::NullResponseBody
        connection.adapter(adapter)
        connection.basic_auth(http_user, http_password)
      end
    end
  end
end