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

    describe 'create_vcs_root' do

      it 'should create a vcs root' do
        pending 'waiting to here back from jetbrains' do
          @tc.create_vcs_root('testvcsroot')
        end
      end
    end
  end
end