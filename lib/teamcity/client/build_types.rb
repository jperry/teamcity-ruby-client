require 'linguistics'

module TeamCity
  class Client
    # Defines methods related to build types (or build configurations)
    module BuildTypes

      Linguistics.use :en

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
        get("buildTypes/#{locator(options)}")
      end

      # TODO: File jetbrains ticket, this call doesn't work
      #def buildtype_state(options={})
      #  assert_options(options)
      #  get("buildTypes/#{locator(options)}/paused")
      #end

      # Get build configuration settings
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration settings
      def buildtype_settings(options={})
        assert_options(options)
        response = get("buildTypes/#{locator(options)}/settings")
        response['property']
      end

      # Get build configuration parameters
      #
      # @param (see #buildtype)
      # @return [Array<Hashie::Mash>] of build configuration parameters
      def buildtype_parameters(options={})
        assert_options(options)
        response = get("buildTypes/#{locator(options)}/parameters")
        response['property']
      end

      # @macro [attach] build configuration settings
      #   @method buildtype_$1(options = {})
      #   Get build configuration $1
      #   @param options [Hash] option keys, :id => buildtype_id
      #   @return [Array<Hashie::Mash>] of build configuration $1
      def self.make_method(name)
        define_method("buildtype_#{name}".to_sym) do |options|
          name_has_dashes = name.to_s.gsub('_', '-')
          assert_options(options)
          response = get("buildTypes/#{locator(options)}/#{name_has_dashes}")
          response[name_has_dashes.en.plural]
        end
      end
      private_class_method :make_method

      make_method :features
      make_method :triggers
      make_method :steps
      make_method :agent_requirements
      make_method :artifact_dependencies
      make_method :snapshot_dependencies

    end
  end
end