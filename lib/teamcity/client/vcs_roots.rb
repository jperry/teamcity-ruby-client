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
      # TODO: Come back, waiting for a response back from jetbrains as this isn't working
      #def create_vcs_root(name)
      #  builder = Builder::XmlMarkup.new
      #  builder.tag!('vcs-root'.to_sym, :name => name, :vcsName => 'jetbrains.git', :shared => "false", :status => "NOT_MONITORED") do |node|
      #    node.project(:id => 'project2')
      #    node.properties do |p|
      #      p.property(:name => 'url', :value => "git@github.com:jperry/teamcity-ruby-client.git")
      #      p.property(:name => "agentCleanFilesPolicy", :value => "ALL_UNTRACKED")
      #      p.property(:name=>"agentCleanPolicy", :value=>"ON_BRANCH_CHANGE")
      #      p.property(:name=>"authMethod", :value=>"ANONYMOUS")
      #      p.property(:name=>"branch", :value=>"master")
      #      p.property(:name=>"ignoreKnownHosts", :value=>"true")
      #      p.property(:name=>"submoduleCheckout", :value=>"CHECKOUT")
      #      p.property(:name=>"usernameStyle", :value=>"USERID")
      #    end
      #  end
      #  post("vcs-roots") do |req|
      #    req.headers['Content-Type'] = 'application/xml'
      #    req.body = builder.target!
      #  end
      #end
    end
  end
end