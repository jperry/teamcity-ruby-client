require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module TeamCity
  # @private
  module Connection
    private

    def connection(options={})
      faraday_options = {
        :headers => {
          'User-Agent' => user_agent
        }.merge((headers = Headers.build(options)).to_hash),
        :ssl => {:verify => false},
        :url => endpoint
      }

      Faraday::Connection.new(faraday_options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        connection.use FaradayMiddleware::ParseJson if headers.accept =~ /json/
        connection.use FaradayMiddleware::NullResponseBody
        connection.adapter(adapter)
        connection.basic_auth(http_user, http_password)
      end
    end
  end
end