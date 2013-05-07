module TeamCity
  class Client
    # Defines methods related to projects
    module Projects

      # List of projects
      #
      # @return [Array<Hashie::Mash>, nil] of projects or nil if no projects exist
      def projects
        response = get('projects')
        response['project']
      end

      # Get project details
      #
      # @param options [Hash] The options hash,
      # @option options [String] :id the project id
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
      # @param options [Hash] copy project options
      # @option options [Boolean] :copyAllAssociatedSettings copy all associated settings
      # @options options[Boolean] :shareVCSRoots when true the vcs roots will be shared, otherwise they will be copied
      # @return [Hashie::Mash] project details
      def copy_project(source_project_id, target_project_name, options={})
        attributes = {
          :name => target_project_name,
          :sourceProjectLocator => "id:#{source_project_id}",
        }
        post("projects") do |req|
          req.headers['Content-Type'] = 'application/xml'
          builder = Builder::XmlMarkup.new
          builder.newProjectDescription(options.merge(attributes))
          req.body = builder.target!
        end
      end

      # Delete a project
      #
      # @param project_id [String] the id of the project
      # @return [nil]
      def delete_project(project_id)
        delete("projects/#{project_id}")
      end
      
      # Delete a project parameter
      #
      # @param project_id [String] the project id
      # @param parameter_name [String] name of the parameter to delete
      # @return [nil]
      def delete_project_parameter(project_id, parameter_name)
        delete("projects/#{project_id}/parameters/#{parameter_name}") do |req|
          # only accepts text/plain
          req.headers['Accept'] = 'text/plain'
        end
      end

      # Set a project parameter (Create or Update)
      #
      #
      # @param project_id [String] the project id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      def set_project_parameter(project_id, parameter_name, parameter_value)
        path = "projects/#{project_id}/parameters/#{parameter_name}"
        put_text_request(path, parameter_value)
      end

      # Set a project field
      #
      # @example Set a projects name
      #   TeamCity.set_project_field('project1', 'name', 'new-name')
      # @example Set a projects description
      #   TeamCity.set_project_field('project1', 'description', 'new-description')
      # @example Archive/Unarchive a project
      #   Teamcity.set_project_field('project1', 'archived', 'true|false')
      #
      # @param project_id [String] the project id
      # @param field_name [String] the field name: 'name', 'description', 'archived'
      # @param field_value [String] the value to set the field to
      def set_project_field(project_id, field_name, field_value)
        path = "projects/#{project_id}/#{field_name}"
        put_text_request(path, field_value)
      end
    end
  end
end