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
        get("buildTypes/#{locator(options)}")
      end

      # Create a Build Configuration
      #
      # @param project_id [String] id of the project you are adding the build configuration
      # @param name [String] name of the buildtype you wish to create
      # @return [Hashie::Mash] of build configuration details
      def create_buildtype(project_id, name)
        post("projects/#{project_id}/buildTypes", :content_type => :text) do |req|
          req.body = name
        end
      end

      # Create a Build Configuration (TC 8.1)
      #
      # @param project_id [String] id of the project you are adding the build configuration to
      # @param name [String] name of the buildtype you wish to create
      # @param options [Hash] options for the buildtype you wish to create
      # @yield [Hash] properties to set, view the official documentation for supported properties
      # @return [Hashie::Mash] of build configuration details
      def create_buildtype_ex(project_id, name, options={}, &block)
        if block_given?
          yield(options)
        end
        attributes = {
            :name => name,
            :project_id => project_id,
            :project => { :id => project_id }
        }.merge(options)

        post("buildTypes", :content_type => :json) do |req|
          req.body = attributes.to_json
        end
      end

      # Get a listing of vcs branches
      #
      # @param buildtype_id [String]
      # @return [Array<Hashie::Mash>]
      def buildtype_branches(buildtype_id)
        path = "buildTypes/#{buildtype_id}/branches"
        response = get(path, :accept => :json, :content_type => :json)
        response.branch
      end

      # Get whether the build is paused or not
      #
      # @param options [Hash] option keys, :id => buildtype_id
      # @return [String] 'true' or 'false' on whether the build is paused
      def buildtype_state(options={})
        assert_options(options)
        path = "buildTypes/#{locator(options)}/paused"
        get(path, :accept => :text, :content_type => :text)
      end

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

      # Get investigation info for build configuration
      #
      # @param buildtype_id [String] the buildtype id
      # @return [Array<Hashie::Mash>] of build investigation info
      def buildtype_investigations(buildtype_id)
        response = get("buildTypes/#{buildtype_id}/investigations")
        response['investigation']
      end

      # List of build types
      #
      # @return [Array<Hashie::Mash>, nil] of buildtypes or nil if no buildtypes exist
      def build_templates
        get("buildTypes/#{locator({'templateFlag'=>'true'})}")
      end

      # Get template associated with build configuration
      #
      # @param (see #buildtype)
      # @return [Hashie::Mash, nil] of build configuration parameters or nil if
      def buildtype_template(options={})
        assert_options(options)
        begin
          get("buildTypes/#{locator(options)}/template")
        rescue StandardError => e
          /No template associated/.match(e.to_s) ? nil : raise
        end
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
          response = get("buildTypes/#{locator(options)}/#{name_has_dashes}", accept: :json)
          response[response.keys.first]
        end
      end

      private_class_method :make_method

      make_method :features
      make_method :triggers
      make_method :steps
      make_method :agent_requirements
      make_method :artifact_dependencies
      make_method :snapshot_dependencies
      make_method :vcs_root_entries

      # Attach a vcs root to a build type (build configuration_)
      #
      #
      # @param buildtype_id [String] the buildtype id
      # @param vcs_root_id [String, Numeric] id of vcs root
      # @return [Hashie::Mash] vcs root object that was attached
      def attach_vcs_root(buildtype_id, vcs_root_id)
        payload = { 'vcs-root' => { :id => vcs_root_id } }

        post("buildTypes/#{buildtype_id}/vcs-root-entries", :content_type => :json) do |req|
          req.body = payload.to_json
        end
      end

      # Set a buildtype parameter (Create or Update)
      #
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      # @return parameter_value [String] that was set
      def set_buildtype_parameter(buildtype_id, parameter_name, parameter_value)
        path = "buildTypes/#{buildtype_id}/parameters/#{parameter_name}"
        put(path, :accept => :text, :content_type => :text) do |req|
          req.body = parameter_value
        end
      end

      # Delete a buildtype parameter
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to delete
      # @return [nil]
      def delete_buildtype_parameter(buildtype_id, parameter_name)
        path = "buildTypes/#{buildtype_id}/parameters/#{parameter_name}"
        delete(path, :accept => :text, :content_type => :text)
        return nil
      end

      # Create a buildtype agent requirement (Create)
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      # @param condition [String] the condition for which to check against
      # @return [Hashie::Mash]
      #
      # @example Create a condition where a system property equals something
      #    TeamCity.create_agent_requirement('bt1', 'system.os.name', 'Linux', 'equals')
      #
      # @note Check the TeamCity UI for supported conditions
      def create_agent_requirement(buildtype_id, parameter_name, parameter_value, condition)
        builder = TeamCity::ElementBuilder.new(:id => parameter_name, :type => condition) do |properties|
          properties['property-name']  = parameter_name
          properties['property-value'] = parameter_value
        end

        path = "buildTypes/#{buildtype_id}/agent-requirements"
        post(path, :accept => :json, :content_type => :json) do |req|
          req.body = builder.to_request_body
        end
      end

      # Delete an agent requirement for a buildtype
      #
      # @param buildtype_id [String] the buildtype_id
      # @param parameter_name [String] name of the requirement to delete
      # @return [nil]
      def delete_agent_requirement(buildtype_id, parameter_name)
        delete("buildTypes/#{buildtype_id}/agent-requirements/#{parameter_name}")
      end

      # Set a buildtype field
      #
      # @example Change buildtype name
      #   TeamCity.set_buildtype_field('bt3', 'name', 'new-name')
      # @example Set buildtype description
      #   TeamCity.set_buildtype_field('bt3', 'description', 'new-description')
      # @example Pause/Unpause a buildtype
      #   Teamcity.set_buildtype_field('buildtype', 'paused', 'true|false')
      #
      # @param buidltype_id [String] the buildtype id
      # @param field_name [String] the field name
      # @param field_value [String] the value to set the field to
      # @return field_value [String] value that was set
      def set_buildtype_field(buildtype_id, field_name, field_value)
        path = "buildTypes/#{buildtype_id}/#{field_name}"
        put(path, :accept => :text, :content_type => :text) do |req|
          req.body = field_value
        end
      end

      # Set buildtype settings
      #
      # @example Cleaning all files between the builds
      #   TeamCity.set_buildtype_setting('bt3', 'cleanBuild', 'true')
      # @example Checkout on the server
      #   TeamCity.set_buildtype_setting('bt3', 'checkoutMode', 'ON_SERVER')
      # @example Fail the build after 10 Minutes
      #   Teamcity.set_buildtype_setting('bt3', 'executionTimeoutMin', '10')
      #
      # @param buidltype_id [String] the buildtype id
      # @param setting_name [String] the settings name
      # @param setting_value [String] the value to set the settings to
      # @return setting_value [String] value that was set
      def set_buildtype_setting(buildtype_id, setting_name, setting_value)
        set_buildtype_field(buildtype_id, "settings/#{setting_name}", setting_value)
      end

      # Delete buildtype (build configuration)
      #
      # @param buildtype_id [String] the id of the buildtype
      # @return [nil]
      def delete_buildtype(buildtype_id)
        delete("buildTypes/#{buildtype_id}")
      end

      # Set build step field
      #
      # @param buildtype_id [String] the id of the buildtype
      # @param step_id [String] the id of the build step
      # @param field_name [String] the name of the field to set
      # @param field_value [String] the value to set the field name to
      # @return [nil]
      def set_build_step_field(buildtype_id, step_id, field_name, field_value)
        path = "buildTypes/#{buildtype_id}/steps/#{step_id}/#{field_name}"
        put(path, :accept => :text, :content_type => :text) do |req|
          req.body = field_value
        end
      end

      # Create Build Step
      #
      # @param buildtype_id [String] :buildtype_id to create the step under
      # @option options [String] :name for the step definition (optional)
      # @option options [String] :type Type of Build Step: 'Maven', 'Ant', etc
      # @yield [Hash] properties to set on the step, view the official documentation for supported properties
      # @return [Hashie::Mash] step object that was created
      #
      # @example Create a Maven2 step that executes the target verify
      #   TeamCity.create_build_step(:buildtype_id => 'my-build-type-id', :type => 'Maven', name: 'Unit Tests') do |properties|
      #     properties['goals'] = 'verify'
      #     properties['mavenSelection'] = 'mavenSelection:default'
      #     properties['pomLocation'] = 'pom.xml'
      #   end
      def create_build_step(buildtype_id, options = {}, &block)
        attributes = {
          :type => options.fetch(:type),
          :name => options.fetch(:name) { nil }
        }

        builder = TeamCity::ElementBuilder.new(attributes, &block)

        post("buildTypes/#{buildtype_id}/steps", :content_type => :json) do |req|
          req.body = builder.to_request_body
        end
      end

      # Create Build Trigger
      #
      # @param buildtype_id [String] :buildtype_id to create the trigger under
      # @option options [String] :type Type of Build Trigger: 'vcsTrigger', 'schedulingTrigger', etc
      # @yield [Hash] properties to set on the trigger, view the official documentation for supported properties
      # @return [Hashie::Mash] trigger object that was created
      #
      # @example Create a a VCS build trigger for checkins
      #   TeamCity.create_build_step(:buildtype_id => 'my-build-type-id', :type => 'vcsTrigger', name: 'Every Checkin') do |properties|
      #     properties['groupCheckkinsByCommitter'] = 'true'
      #     properties['perCheckinTriggering'] = 'true'
      #     properties['quietPeriodMode'] = 'DO_NOT_USE'
      #   end
      def create_build_trigger(buildtype_id, options = {}, &block)
        attributes = {
          :type => options.fetch(:type),
        }

        builder = TeamCity::ElementBuilder.new(attributes, &block)

        post("buildTypes/#{buildtype_id}/triggers", :content_type => :json) do |req|
          req.body = builder.to_request_body
        end
      end
    end
  end
end
