module TeamCity
  class Client
    # Defines methods related to build types (or build configurations)
    module BuildTypes

      # HTTP GET

      # List of build types
      #
      # @return [Array<Hashie::Mash>, nil] of buildtypes or nil if no buildtypes exist
      def buildtypes
        response = get('buildTypes')
        response['buildType']
      end

      # Get build configuration details
      #
      # @param options [Hash] option keys, :id => buildtype_id
      # @return [Hashie::Mash] of build configuration details
      def buildtype(options={})
        assert_options(options)
        get("buildTypes/#{buildtype_locator(options)}")
      end

      # TODO: File jetbrains ticket, this call doesn't work
      #def buildtype_state(options={})
      #  assert_options(options)
      #  get("buildTypes/#{buildtype_locator(options)}/paused")
      #end

      # Get build configuration settings
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration settings
      def buildtype_settings(options={})
        assert_options(options)
        response = get("buildTypes/#{buildtype_locator(options)}/settings")
        response['property']
      end

      # Get build configuration parameters
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration parameters
      def buildtype_parameters(options={})
        assert_options(options)
        response = get("buildTypes/#{buildtype_locator(options)}/settings")
        response['property']
      end

      # Get build configuration steps
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration steps
      def buildtype_steps(options={})
        assert_options(options)
        response = get("buildTypes/#{buildtype_locator(options)}/steps")
        response['step']
      end

      # Get build configuration features
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration features
      def buildtype_features(options={})
        assert_options(options)
        response = get("buildTypes/#{buildtype_locator(options)}/features")
        response['feature']
      end

      private

      def assert_options(options)
        !options[:id] and raise ArgumentError, "Must provide an id"
      end

      def buildtype_locator(options={})
        "id:#{options[:id]}"
      end

    end
  end
end