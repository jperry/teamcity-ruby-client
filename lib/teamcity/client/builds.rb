module TeamCity
  class Client
    # Defines methods related to builds
    module Builds

      # HTTP GET

      # List of builds
      #
      # @param options [Hash] list of build locators to filter build results on
      # @return [Array<Hashie::Mash>, nil] of builds or nil if no builds exist
      def builds(options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)}"
        response = get("builds#{url_params}")
        response['build']
      end

      # Get build details
      #
      # @param options [Hash] option keys, :id => build_id
      # @return [Hashie::Mash] of build details
      def build(options={})
        assert_options(options)
        get("builds/#{locator(options)}")
      end

      def build_tags(options={})
        assert_options(options)
        response = get("builds/#{locator(options)}/tags")
        response['tag']
      end


    end
  end
end