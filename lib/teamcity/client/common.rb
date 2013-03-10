module TeamCity
  class Client
    # Defines some common methods shared across the other
    # teamcity api modules
    module Common

      private

      def assert_options(options)
        !options[:id] and raise ArgumentError, "Must provide an id"
      end

      def locator(options={})
        "id:#{options[:id]}"
      end
    end
  end
end