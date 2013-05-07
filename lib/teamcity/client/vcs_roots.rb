module TeamCity
  class Client
    module VCSRoots

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
      # @param vcs_name [String] Name of the vcs root
      # @param vcs_type [String] Type of VCS: 'git', 'perforce', etc
      # @param options [Hash] VCS root options
      # @option options [String] :projectLocator the project id (not required if :shared => true)
      # @option options [Boolean] :shared whether the vcs root is shared across projects
      # @yield [Hash] properties to set on the vcs root, view the page source of the vcs root page for the id and value of a property
      # @return [Hashie::Mash] vcs root object that was created
      #
      # @example Create a Git VCS Root that pulls from master that is only shared within a project and uses the default private key
      #   TeamCity.create_vcs_root('my-git-vcs-root', 'git', :projectLocator => 'project2') do |properties|
      #     properties['branch'] = 'master'
      #     properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
      #     properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
      #     properties['ignoreKnownHosts'] = true
      #   end
      def create_vcs_root(vcs_name, vcs_type, options = {}, &block)
        attributes = {
          :name    => vcs_name,
          :vcsName => "jetbrains.#{vcs_type}"
        }
        builder = Builder::XmlMarkup.new
        builder.tag!('vcs-root'.to_sym, options.merge(attributes)) do |node|
          node.properties do |p|
            if block_given?
              properties = {}
              yield(properties)
              properties.each do |name, value|
                p.property(:name => name, :value => value)
              end
            end
          end
        end
        post("vcs-roots") do |req|
          req.headers['Content-Type'] = 'application/xml'
          req.body = builder.target!
        end
      end
    end
  end
end