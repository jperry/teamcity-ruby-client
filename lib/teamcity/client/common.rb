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
    end
  end
end