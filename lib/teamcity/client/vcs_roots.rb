module TeamCity
  class Client
    module VCSRoots

      VCS_TYPES = { 'git' => 'jetbrains.git' }

      # List of VCS Roots
      #
      # @return [Array<Hashie::Mash>, nil] of vcs roots or nil if no vcs roots exist
      def vcs_roots
        response = get('vcs-roots')
        response['vcs-root']
      end

      # Get VCS Root details
      #
      # @param vcs_root_id [String, Numeric]
      # @return [Hashie::Mash]
      def vcs_root_details(vcs_root_id)
        get("vcs-roots/id:#{vcs_root_id}")
      end

      # Create VCS Root
      #
      # @option options [String] :vcs_name Name of the vcs root
      # @option options [String] :vcs_type Type of VCS: 'git', 'perforce', etc
      # @option options [String] :project_id to create the vcs root under
      # @yield [Hash] properties to set on the vcs root, view the page source of the vcs root page for the id and value of a property
      # @return [Hashie::Mash] vcs root object that was created
      #
      # @example Create a Git VCS Root that pulls from master that is only shared with it's project and sub-projecdts and uses the default private key
      #   TeamCity.create_vcs_root(:vcs_name => 'my-git-vcs-root', :vcs_type => 'git', :project_id => 'project2') do |properties|
      #     properties['branch'] = 'master'
      #     properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
      #     properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
      #     properties['ignoreKnownHosts'] = true
      #   end
      def create_vcs_root(options = {}, &block)
        attributes = {
          :name    => options.fetch(:vcs_name),
          :vcsName => VCS_TYPES[options.fetch(:vcs_type)] || options.fetch(:vcs_type),
          :projectLocator => options.fetch(:project_id)
        }
        builder = TeamCity::ElementBuilder.new(attributes, &block)
        post("vcs-roots", :content_type => :json) do |req|
          req.body = builder.to_request_body
        end
      end
    end
  end
end
