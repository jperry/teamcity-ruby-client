require_relative '../../spec_helper'

describe 'Projects' do

  before(:each) do
    @tc = TeamCity
  end

  after(:all) do
    TeamCity.reset
  end

  # GET requests
  describe 'GET', :vcr do

    before(:all) do
      TeamCity.configure do |config|
        config.endpoint = 'http://localhost:8111/guestAuth/app/rest/7.0/'
      end
    end

    before(:each) do
      @tc = TeamCity
    end

    describe '.projects' do

      it 'should fetch projects' do
        @tc.projects.should_not be_nil
      end

      it 'should return nil if there are no projects' do
        @tc.projects.should be_nil
      end
    end

    describe '.project' do

      it 'should fetch a single project by id' do
        @tc.project(id: 'project2').should_not be_nil
      end

      it 'should raise an error if the project does not exist' do
        expect { @tc.project(id: 'missing') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.project }.to raise_error
      end
    end

    describe '.project_buildtypes' do

      it 'should fetch all the buildTypes for a project' do
        bts = @tc.project_buildtypes(id: 'project2')
        bts.each do |bt|
          bt.projectId.should eq('project2')
        end
      end

      it 'should return nil if the project does not have any build build types' do
        bts = @tc.project_buildtypes(id: 'project5')
        bts.should be_nil
      end
    end

    describe '.project_parameters' do
      it 'should fetch all the paramters for a given project' do
        parameters = @tc.project_parameters(id: 'project2')
        parameters.size.should eq(3)
      end

      it 'should return nil if there are no parameters defined for a project' do
        parameters = @tc.project_parameters(id: 'project3')
        parameters.should be_nil
      end

      it 'should raise an error if the project does not exist' do
        expect { @tc.project_parameters(id: 'missing')}
      end
    end
  end

  # POST Requests
  describe 'POST', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.create_project' do
      it 'should create a project' do
        response = @tc.create_project('test-create-project')
        response.id.should match(/project/)
      end
    end

    describe '.copy_project' do
      it 'should copy a project' do
        source_project = @tc.create_project('copy-project-testA')
        copied_project_name = 'copy-project-testB'
        response = @tc.copy_project(source_project.id, copied_project_name)
        response.name.should eq(copied_project_name)
      end
    end
  end

  describe 'DELETE', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.delete_project' do
      it 'should delete a project' do
        response = @tc.create_project('project-to-delete')
        @tc.delete_project(response.id).should be_nil
      end
    end

    describe '.delete_project_parameter' do
      it 'should delete a project parameter' do
        response = @tc.delete_project_parameter('project2', 'delete-this-parameter')
        response.should be_nil
      end
    end
  end

  describe 'PUT', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.set_project_parameter' do
      it 'should set a project parameter' do
        @tc.set_project_parameter('project2', 'set-this-parameter', 'some-value')
      end
    end
  end
end