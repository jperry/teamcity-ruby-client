require_relative '../../spec_helper'

describe 'Projects' do

  before(:each) do
    @tc = TeamCity
  end

  before(:all) do
    TeamCity.configure do |config|
      config.endpoint = 'http://localhost:8111/guestAuth/app/rest/7.0/'
    end
  end

  after(:all) do
    TeamCity.reset
  end

  # Get requests
  describe 'GET' do

    describe '.projects' do

      it 'should fetch projects', :vcr do
        @tc.projects.should_not be_nil
      end

      it 'should return nil if there are no projects', :vcr do
        @tc.projects.should be_nil
      end
    end

    describe '.project' do

      it 'should fetch a single project by id', :vcr do
        @tc.project(id: 'project2').should_not be_nil
      end

      it 'should raise an error if the project does not exist', :vcr do
        expect { @tc.project(id: 'missing') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.project }.to raise_error
      end
    end

    describe '.project_buildtypes' do

      it 'should fetch all the buildTypes for a project', :vcr do
        bts = @tc.project_buildtypes(id: 'project2')
        bts.each do |bt|
          bt.projectId.should eq('project2')
        end
      end

      it 'should return nil if the project does not have any build build types', :vcr do
        bts = @tc.project_buildtypes(id: 'project5')
        bts.should be_nil
      end
    end

  end
end