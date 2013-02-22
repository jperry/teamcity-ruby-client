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

    describe '.projects', :vcr do

      it 'should fetch projects' do
        @tc.projects.should_not be_nil
      end
    end

    describe '.project' do

      it 'should fetch a single project by id', :vcr do
        @tc.project(id: 'project2').should_not be_nil
      end

      it 'should raise an error if no options are provided' do
        expect { @tc.project }.to raise_error
      end

      it 'should raise an error if the option key is not supported' do
        expect { @tc.project(foo: 'bar') }
      end

      it 'should raise an error if the id provided is not of the correct format' do
        expect { @tc.project(id: '123') }
      end
    end

    describe '.project_buildtypes' do

      it 'should fetch all the buildTypes for a project', :vcr do
        bts = @tc.project_buildtypes(id: 'project2')
        bts.each do |bt|
          bt.projectId.should eq('project2')
        end
      end
    end

  end
end