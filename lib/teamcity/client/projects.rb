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

      # Create an empty project
      #
      # @param name [String] Name of the project
      # @return [Hashie::Mash] project details
      def create_project(name)
        post("projects") do |req|
          req.headers['Content-Type'] = 'text/plain'
          req.body = name
        end
      end

      # Copy another project
      #
      # @param source_project_id [String] id of the project you wish to copy
      # @param target_project_name [String] name of the project you want to create
      # @return [Hashie::Mash] project details
      def copy_project(source_project_id, target_project_name)
        post("projects") do |req|
          req.headers['Content-Type'] = 'application/xml'
          req.body = "<newProjectDescription name='#{target_project_name}' sourceProjectLocator='id:#{source_project_id}' copyAllAssociatedSettings='true' shareVCSRoots='false'/>"
        end
      end
    end
  end
end