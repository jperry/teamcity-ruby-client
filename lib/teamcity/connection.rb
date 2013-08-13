require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module TeamCity
  # @private
  module Connection
    private

    def connection(options={})
      headers = case options[:format]
        when :text
          {'Accept' => "text/plain; charset=utf-8", 'User-Agent' => user_agent}
        else
          {'Accept' => "application/json; charset=utf-8", 'User-Agent' => user_agent}
        end

      connection_options = {
        :headers => headers,
        :ssl => {:verify => false},
        :url => endpoint
      }

      Faraday::Connection.new(connection_options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        connection.use FaradayMiddleware::ParseJson unless options[:format] == :text
        connection.use FaradayMiddleware::NullResponseBody
        connection.adapter(adapter)
        connection.basic_auth(http_user, http_password)
      end
    end
  end
end