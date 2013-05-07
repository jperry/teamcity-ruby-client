module TeamCity
  class Client
    # Defines some common methods shared across the other
    # teamcity api modules
    module Common

      private

      def assert_options(options)
        !options[:id] and raise ArgumentError, "Must provide an id", caller
      end

      # Take a list of locators to search on multiple criterias
      #
      def locator(options={})
        options.inject([]) do |locators, locator|
          key, value = locator
          locators << "#{key}:#{value}"
        end.join(',')
      end

      # Put request helper where the body is text
      #
      # @param path [String] request path
      # @param body [String] body contents of the request
      # @return [nil]
      def put_text_request(path, body)
        put(path) do |req|
          req.headers['Content-Type'] = 'text/plain'
          req.body = body
        end
      end
    end
  end
end