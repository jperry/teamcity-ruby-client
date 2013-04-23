module TeamCity
  class Client
    # Defines methods related to builds
    module Builds

      # HTTP GET

      # List of builds
      #
      # @return [Array<Hashie::Mash>, nil] of builds or nil if no builds exist
      def builds
        response = get('builds')
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


    end
  end
end