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

      # TODO: Will need to create a Faraday middleware for this
      # since the response returns a string not a json object
      #def build_pinned?(id)
      #  path = "builds/#{id}/pin"
      #  get(path) do |req|
      #    req.headers['Accept'] = 'text/plain'
      #  end
      #end

      # HTTP PUT

      # Pin a build
      #
      # @param id [String] build to pin
      # @param comment [String] provide a comment to the pin
      # @return [nil]
      def pin_build(id, comment='')
        path = "builds/#{id}/pin"
        put_text_request(path, comment)
      end

      # HTTP DELETE

      # Unpin a build
      #
      # @param id [String] build to unpin
      # @return [nil]
      def unpin_build(id)
        delete("builds/#{id}/pin")
      end
    end
  end
end