module TeamCity
  class Client
    # Defines methods related to projects
    module Projects

      # HTTP GET

      # List of projects
      #
      # @return [Array<Hashie::Mash>] of projects
      def projects
        response = get('projects')
        response['project']
      end

      # Get project details
      #
      # @param options [Hash] option keys, :id => project_id
      # @return [Hashie::Mash] of project details
      def project(options={})
        !options[:id] and raise ArgumentError, "Must provide an id"
        locator = "id:#{options[:id]}"
        get("projects/#{locator}")
      end

      # List of Build Configurations of a project
      #
      # @param (see #project)
      # @return [Array<Hashie::Mash>] of build types
      def project_buildtypes(options={})
        !options[:id] and raise ArgumentError, "Must provide an id"
        locator = "id:#{options[:id]}"
        response = get("projects/#{locator}/buildTypes")
        response['buildType']
      end
    end
  end
end