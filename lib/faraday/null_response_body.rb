# @private
module FaradayMiddleware
  # @private
  class NullResponseBody < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        if response[:body] == "null"
          response[:body] = {}
        end
      end
    end
  end
end