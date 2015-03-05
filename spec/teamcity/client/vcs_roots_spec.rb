require_relative '../../spec_helper'

describe 'VCSRoots' do

  before(:each) do
    @tc = TeamCity
    configure_client_with_authentication
  end

  # GET requests
  describe 'GET', :vcr do
    describe '.vcs_roots' do
      it 'should fetch vcs roots' do
        @tc.vcs_roots.should have_at_least(1).items
      end
    end

    describe '.vcs_root_details' do
      it 'should fetch the vcs root details' do
        vcs_root_id = @tc.vcs_roots.first.id
        response = @tc.vcs_root_details(vcs_root_id)
        response.id.should eq(vcs_root_id)
      end
    end
  end

  describe 'POST', :vcr do
    describe '.create_vcs_root' do
      it 'should create a git vcs root that is shared with the project and sub-projects' do
        project_id = @tc.projects[1].id
        vcs_name = 'PostCreateVCSRootGit'
        vcs_type = 'git'
        response = @tc.create_vcs_root(vcs_name: vcs_name, vcs_type: vcs_type, project_id: project_id) do |properties|
          properties['branch'] = 'master'
          properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
          properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
          properties['ignoreKnownHosts'] = true
        end
        response.name.should eq(vcs_name)
        response.vcsName.should match(/#{vcs_type}/)
      end

      it 'should create a subversion vcs root that is shared with the project and sub-projects' do
        project_id = @tc.projects[1].id
        vcs_name = 'PostCreateVCSRootSvn'
        vcs_type = 'svn'
        response = @tc.create_vcs_root(vcs_name: vcs_name, vcs_type: vcs_type, project_id: project_id) do |properties|
          properties['branch'] = 'master'
          properties['url'] = 'http://svn.example.com/jperry/teamcity-ruby-client'
          properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
          properties['ignoreKnownHosts'] = true
        end
        response.name.should eq(vcs_name)
        response.vcsName.should match(/#{vcs_type}/)
      end
    end
  end

  describe 'PUT', :vcr do

    describe '.set_vcs_root_field' do
      it 'should set a vcs modification check interval' do
        vcs_root_name = 'PutSetCheckIntervalField'
        project = @tc.projects[1]
        @tc.create_vcs_root(vcs_name: vcs_root_name,
                            vcs_type: 'git',
                            project_id:  project.id) do |properties|
          properties['branch'] = 'master'
          properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
          properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
          properties['ignoreKnownHosts'] = true
        end

        vcs_root_id = project.id + "_" + vcs_root_name

        field_value = 86400
        @tc.set_vcs_root_field(vcs_root_id,
                               'modificationCheckInterval',
                               field_value.to_s).should eq(field_value.to_s)

        vcs = @tc.vcs_root_details(vcs_root_id)
        vcs.modificationCheckInterval.should eq(field_value)
      end
    end
  end
end
