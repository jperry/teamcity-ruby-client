module TeamCity
  class Client
    # Defines methods related to projects
    module Projects

      # HTTP GET

      # List of projects
      #
      # @return [Array<Hashie::Mash>, nil] of projects or nil if no projects exist
      def projects
        response = get('projects')
        response['project']
      end

      # Get project details
      #
      # @param options [Hash] option keys, :id => project_id
      # @return [Hashie::Mash] of project details
      def project(options={})
        assert_options(options)
        get("projects/#{locator(options)}")
      end

      # List of Build Configurations of a project
      #
      # @param (see #project)
      # @return [Array<Hashie::Mash>, nil] of build types or nil if no build types exist
      def project_buildtypes(options={})
        assert_options(options)
        response = get("projects/#{locator(options)}/buildTypes")
        response['buildType']
      end

      # List of parameters defined on a project
      #
      # @param (see #project)
      # @return [Array<Hashie::Mash>, nil] of parameters or nil if no parameters are defined
      def project_parameters(options={})
        assert_options(options)
        response = get("projects/#{locator(options)}/parameters")
        response['property']
      end
    end
  end
end