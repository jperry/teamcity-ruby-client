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
        config.endpoint = 'http://localhost:8111/guestAuth/app/rest'
      end
    end

    before(:each) do
      @tc = TeamCity
    end

    describe '.projects' do
      it 'should fetch projects' do
        @tc.projects.should_not be_nil
      end
    end

    describe '.project' do

      it 'should fetch a single project by id' do
        @tc.project(id: 'GetProjectRequest').should_not be_nil
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
        bts = @tc.project_buildtypes(id: 'GetProjectBuildTypes')
        bts.each do |bt|
          bt.projectId.should eq('GetProjectBuildTypes')
        end
      end

      it 'should return nil if the project does not have any build types' do
        bts = @tc.project_buildtypes(id: 'GetProjectWithNoBuildTypes')
        bts.should be_empty
      end
    end

    describe '.project_parameters' do
      it 'should fetch all the paramters for a given project' do
        parameters = @tc.project_parameters(id: 'GetProjectWithParameters')
        parameters.size.should_not eq(0)
      end

      it 'should return nil if there are no parameters defined for a project' do
        parameters = @tc.project_parameters(id: 'GetProjectWithNoParameters')
        parameters.should be_empty
      end

      it 'should raise an error if the project does not exist' do
        expect { @tc.project_parameters(id: 'missing')}
      end
    end

    describe '.parent_project' do
      it 'should fetch the parent project for a given project' do
        parent = @tc.parent_project(id: 'GetProjectWithParent').should_not be_nil
      end

      it 'should return nil if there is no parent project for a given project' do
        parent = @tc.parent_project(id: 'GetProjectWithNoParent').should be_nil
      end

      it 'should raise an error if the project does not exist' do
        expect { @tc.parent_project(id: 'missing') }
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
        response = @tc.create_project('PostCreateProject')
        response.id.should eq('PostCreateProject')
      end
    end

    describe '.create_sub_project' do
      it 'should create a sub project' do
        parent = @tc.create_project('ParentProject')
        response = @tc.create_sub_project('SubProject', parent.id, :id => 'SubProjectManualSetID' )

        response.name.should eq('SubProject')
        response.id.should eq('SubProjectManualSetID')
        response.parentProject.id.should eq(parent.id)
      end
    end

    describe '.copy_project' do
      it 'should copy a project' do
        @tc.create_project('PostProjectToBeCopied')
        source_project = @tc.project(id: 'PostProjectToBeCopied')
        copied_project_name = 'PostCopyProject'
        response = @tc.copy_project(
          source_project.id,
          copied_project_name,
          :copyAllAssociatedSettings => true
        )
        response.name.should eq(copied_project_name)
      end

      it 'should copy a project and set the attributes' do
        @tc.create_project('PostProjectToBeCopied')
        source_project = @tc.project(id: 'PostProjectToBeCopied')
        copied_project_name = 'PostCopyProject'
        response = @tc.copy_project(
            source_project.id,
            copied_project_name,
            :copyAllAssociatedSettings => true,
            :id => 'CopiedProjectId'
        )
        response.id.should eq('CopiedProjectId')
      end
    end
  end

  describe 'DELETE', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.delete_project' do
      it 'should delete a project' do
        response = @tc.create_project('ProjectToDelete')
        @tc.delete_project(response.id).should be_nil
      end
    end

    describe '.delete_project_parameter' do
      it 'should delete a project parameter' do
        project_id = 'DeleteProjectParameters'
        param_to_delete = 'delete-this-param'
        @tc.create_project(project_id)
        @tc.set_project_parameter(project_id, param_to_delete, 'delete-me')
        response = @tc.delete_project_parameter(project_id, param_to_delete)
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
        project_id = 'PutCreateProjectParam'
        param_name = 'set-with-param'
        param_value = 'some-value'
        @tc.create_project(project_id)
        @tc.set_project_parameter(project_id, param_name, param_value).should eq(param_value)
      end
    end

    describe '.set_project_field' do
      it 'should set a projects name' do
        project_id = 'PutSetProjectNameField'
        @tc.create_project(project_id)
        field_value = 'PutNewProjectName'
        @tc.set_project_field(project_id, 'name', field_value).should eq(field_value)
      end

      it 'should set a projects description' do
        project_id = 'PutSetProjectDescriptionField'
        @tc.create_project(project_id)
        field_value = 'description-changed-by-test'
        @tc.set_project_field(project_id, 'description', field_value).should eq(field_value)
      end

      it 'should archive a project' do
        project_id = 'PutSetProjectArchiveField'
        @tc.create_project(project_id)
        field_value = 'true'
        @tc.set_project_field(project_id, 'archived', field_value).should eq(field_value)
      end
    end

    describe '.set_parent_project' do
      it 'should set a parent project for a given project' do
        project_id = 'PutSetParentProject'
        @tc.create_project(project_id)

        parent_project_id = 'PutParentProject'
        @tc.create_project(parent_project_id)

        @tc.set_parent_project(project_id, parent_project_id)['id'].should eq(project_id)
      end

      it 'should raise an error if the parent project does not exist' do
        expect { @tc.parent_project('GetProjectWithoutParent', 'missing') }.to raise_error
      end

      it 'should raise an error if the child project does not exist' do
        expect { @tc.parent_project('missing', 'GetParentProject') }.to raise_error
      end
    end
  end
end
