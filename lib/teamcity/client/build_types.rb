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

      # Get build investigation info
      #
      # @param buildtype_id [String] the buildtype id
      # @return [Array<Hashie::Mash>] of build investigation info
      def buildtype_investigations(buildtype_id)
        response = get("buildTypes/#{buildtype_id}/investigations")
        response['investigation']
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
      make_method :vcs_root_entries

      # Attach a vcs root to a build type (build configuration_)
      #
      #
      # @param buildtype_id [String] the buildtype id
      # @param vcs_root_id [String, Numeric] id of vcs root
      # @return [Hashie::Mash] vcs root object that was attached
      def attach_vcs_root(buildtype_id, vcs_root_id)
        builder = Builder::XmlMarkup.new
        builder.tag!('vcs-root-entry'.to_sym) do |node|
          node.tag!('vcs-root'.to_sym, :id => vcs_root_id)
        end
        post("buildTypes/#{buildtype_id}/vcs-root-entries") do |req|
          req.headers['Content-Type'] = 'application/xml'
          req.body = builder.target!
        end
      end

      # Set a buildtype parameter (Create or Update)
      #
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      # @return [nil]
      def set_buildtype_parameter(buildtype_id, parameter_name, parameter_value)
        path = "buildTypes/#{buildtype_id}/parameters/#{parameter_name}"
        put_text_request(path, parameter_value)
      end

      # Delete a buildtype parameter
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to delete
      # @return [nil]
      def delete_buildtype_parameter(buildtype_id, parameter_name)
        delete("buildTypes/#{buildtype_id}/parameters/#{parameter_name}") do |req|
          # only accepts text/plain
          req.headers['Accept'] = 'text/plain'
        end
      end

      # Create a buildtype agent requirement (Create)
      #
      # @param buildtype_id [String] the buildtype id
      # @param parameter_name [String] name of the parameter to set
      # @param parameter_value [String] value of the parameter
      # @param condition [String] the condition for which to check against
      # @return [nil]
      #
      # @example Create a condition where a system property equals something
      #    TeamCity.create_agent_requirement('bt1', 'system.os.name', 'Linux', 'equals')
      #
      # @note Check the TeamCity UI for supported conditions
      def create_agent_requirement(buildtype_id, parameter_name, parameter_value, condition)
        builder = Builder::XmlMarkup.new
        builder.tag!('agent-requirement'.to_sym, :id => parameter_name, :type => condition) do |node|
          node.properties do |p|
            p.property(:name => 'property-name', :value => parameter_name)
            p.property(:name => 'property-value', :value => parameter_value)
          end
        end
        post("buildTypes/#{buildtype_id}/agent-requirements") do |req|
          req.headers['Content-Type'] = 'application/xml'
          req.body = builder.target!
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
      def set_buildtype_field(buildtype_id, field_name, field_value)
        path = "buildTypes/#{buildtype_id}/#{field_name}"
        put_text_request(path, field_value)
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
        put_text_request(path, field_value)
      end
    end
  end
end