require_relative '../../spec_helper'

describe 'VCSRoots' do

  before(:each) do
    @tc = TeamCity
  end

  before(:all) do
    TeamCity.configure do |config|
      configure_client_with_authentication
    end
  end

  after(:all) do
    TeamCity.reset
  end

  # GET requests
  describe 'GET', :vcr do
    describe '.vcs_roots' do

      it 'should fetch vcs roots' do
        @tc.vcs_roots.should_not be_nil
      end
    end

    describe '.vcs_root_details' do

      it 'should fetch the vcs root details' do
        @tc.vcs_root_details(1)
      end
    end
  end

  describe 'POST', :vcr do

    describe '.create_vcs_root' do

      it 'should create a vcs root that is only shared within a project' do
        vcs_name = 'testvcsroot'
        vcs_type = 'git'
        response = @tc.create_vcs_root(vcs_name, vcs_type, :projectLocator => 'project2') do |properties|
          properties['branch'] = 'master'
          properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
          properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
          properties['ignoreKnownHosts'] = true
        end
        response.name.should eq(vcs_name)
        response.vcsName.should match(/#{vcs_type}/)
        response.shared.should be_false
      end

      it 'should create a shared vcs root' do
        response = @tc.create_vcs_root('sharedvcsroot', 'git', :shared => true) do |properties|
          properties['branch'] = 'master'
          properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
        end
        response.shared.should be_true
      end
    end
  end
end