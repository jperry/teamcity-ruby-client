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
      # @return [Array<Hashie::Mash> of build types (an empty array will be returne if none exist)
      def project_buildtypes(options={})
        assert_options(options)
        response = get("projects/#{locator(options)}/buildTypes")
        response['buildType']
      end

      # List of parameters defined on a project
      #
      # @param (see #project)
      # @return [Array<Hashie::Mash>] of parameters (empty if none are defined)
      def project_parameters(options={})
        assert_options(options)
        response = get("projects/#{locator(options)}/parameters")
        response['property']
      end

      # Get parent project
      #
      # @param (see #project)
      # @return [Hashie::Mash] of the parent project details
      # @note Only supported for TeamCity Server version >= 8
      def parent_project(options={})
        assert_options(options)
        response = get("projects/#{locator(options)}/parentProject")
        return nil if response['id'] == '_Root'
        response
      end

      # Create an empty project
      #
      # @param name [String] Name of the project
      # @return [Hashie::Mash] project details
      def create_project(name)
        post("projects", :content_type => :text) do |req|
          req.body = name
        end
      end

      # Copy another project
      #
      # @param source_project_id [String] id of the project you wish to copy
      # @param target_project_name [String] name of the project you want to create
      # @param options [Hash] copy project options
      # @option options [Boolean] :copyAllAssociatedSettings copy all associated settings
      # @options options [String] :parentProject used to define the parent project to create this project under (root will be use by default)
      # @options options [String] :id to use for the new project
      # @return [Hashie::Mash] project details
      def copy_project(source_project_id, target_project_name, options={})
        attributes = {
          :name => target_project_name
        }
        builder = Builder::XmlMarkup.new
        builder.tag!(:newProjectDescription ,options.merge(attributes)) do |node|
          node.tag!(:sourceProject, locator: source_project_id)
        end
        post("projects", :content_type => :xml) do |req|
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
        path = "projects/#{project_id}/parameters/#{parameter_name}"
        delete(path, :accept => :text)
      end

      # Set a project parameter (Create or Update)
      #
      #
      # @param project_id [String] the project id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      # @return [String] parameter_value that was set
      def set_project_parameter(project_id, parameter_name, parameter_value)
        path = "projects/#{project_id}/parameters/#{parameter_name}"
        put(path, :content_type => :text, :accept => :text) do |req|
          req.body = parameter_value
        end
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
      # @return [String] project_field_value that was set
      def set_project_field(project_id, field_name, field_value)
        path = "projects/#{project_id}/#{field_name}"
        put(path, :content_type => :text, :accept => :text) do |req|
          req.body = field_value
        end
      end

      # Set a parent for a given project
      #
      # @example Set project1 as parent for project2
      #   TeamCity.set_parent_project('project2', 'project1')
      #
      # @param project_id [String] the project id
      # @param parent_project_id [String] the parent project id
      # @return [Hashie::Mash] of child project details
      # @note Only supported for TeamCity Server version >= 8
      def set_parent_project(project_id, parent_project_id)
        path = "projects/#{project_id}/parentProject"
        builder = Builder::XmlMarkup.new
        builder.tag!(:'project-ref', :id => parent_project_id)
        put(path, :content_type => :xml) do |req|
          req.body = builder.target!
        end
      end
    end
  end
end
