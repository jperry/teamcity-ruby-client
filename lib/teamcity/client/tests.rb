module TeamCity
  class Client
    # Defines methods related to tests
    module Tests
      # HTTP GET

      # List of tests
      #
      # @param options [Hash] list of test locators to filter test results on
      # @return [Array<Hashie::Mash>] of tests (empty array if no tests exist)
      def tests(options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)}"
        tests = []
        begin
          response = get("testOccurrences#{url_params}")
          tests = response.testOccurrence
        rescue
          tests = []
        end
        tests
      end
    end
  end
end
