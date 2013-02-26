module FaradayMiddleware
  # This middleware handles any responses where the body
  # is 'null' which is the case when asking teamcity for
  # an empty collection.  When this is encountered we
  # set the response to an empty json object
  class NullResponseBody < Faraday::Middleware
    # Faraday Middleware
    # @note - should only be called by Faraday
    def call(env)
      @app.call(env).on_complete do |response|
        if response[:body] == "null"
          response[:body] = {}
        end
      end
    end
  end
end