require_relative '../../spec_helper'

describe 'BuildTypes' do

  before(:each) do
    @tc = TeamCity
  end

  after(:all) do
    TeamCity.reset
  end

  # Get requests
  describe 'GET', :vcr do

    before(:each) do
      TeamCity.reset
      TeamCity.configure do |config|
        config.endpoint = 'http://localhost:8111/guestAuth/app/rest'
      end
      @tc = TeamCity
    end

    describe '.buildtypes' do
      it 'should fetch all the buildtypes' do
        build_types = @tc.buildtypes
        build_types.should_not be_empty
      end
    end

    describe '.buildtype' do
      it 'should fetch the details of a buildtype by id' do
        build_type = @tc.buildtypes[0]
        @tc.buildtype(id: build_type.id).id.should_not be_empty
      end

      it 'should raise an error if the buildtype does not exist' do
        expect { @tc.buildtype(id: 'missing') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.buildtype }.to raise_error
      end
    end

    describe '.buildtype_branches' do
      it 'should fetch vcs branches the vcs root is configured to use' do
        buildtype_id = 'BuildTypeTests_GetBuildTypeConfigTests'
        @tc.buildtype_branches(buildtype_id).first.name.should  eq('refs/heads/master')
      end
    end

    describe '.buildtype_state' do
      it 'should fetch the state of the buildtype' do
        build_type = @tc.buildtypes[0]
        @tc.buildtype_state(id: build_type.id).should eq('false')
      end
    end

    describe '.buildtype_settings' do

      before(:each) do
        @build_type = @tc.buildtypes[0]
      end

      it 'should fetch the settings for a given buildtype' do
        @tc.buildtype_settings(id: @build_type.id).should_not be_empty
      end

      it 'should return an array' do
        @tc.buildtype_settings(id: @build_type.id).should be_kind_of(Array)
      end
    end

    describe '.buildtype_template' do
      it 'should return the attributes of the associated template' do
        @tc.buildtype_template(id: 'BuildTypeTests_BuildTypeWithTemplate').id.should_not be_nil
      end

      it 'should return nil if the buildtype is not associated with a template' do
        @tc.buildtype_template(id: 'BuildTypeTests_BuildTypeWithNoTemplate').should be_nil
      end

      it 'should return a list of defined templates' do
        @tc.build_templates.should_not be_nil
      end
    end

    [
      :parameters,
      :steps,
      :features,
      :triggers,
      :agent_requirements,
      :snapshot_dependencies,
      :artifact_dependencies,
      :vcs_root_entries
    ].each do |type|
      describe ".buildtype_#{type}" do

        before(:each) do
          @method_name = "buildtype_#{type}"
          @buildtype_id_with_settings = 'BuildTypeTests_GetBuildTypeConfigTests'
          @buildtype_id_with_no_settings = 'BuildTypeTests_GetBuildTypeEmptyConfigTests'
        end

        it "should fetch the build configuration #{type} for a buildtype" do
          @tc.send(@method_name, id: @buildtype_id_with_settings).should have_at_least(1).items
        end

        it 'should return an array' do
          @tc.send(@method_name, id: @buildtype_id_with_settings).should be_kind_of(Array)
        end

        it "should return nil if there are no #{type} defined" do
          @tc.send(@method_name, id: @buildtype_id_with_no_settings).should be_empty
        end
      end
    end

    describe '.buildtype_investigations' do
      before(:each) do
        configure_client_with_authentication
      end

      it 'should get investigation details' do
        @tc.buildtype_investigations('BuildTypeTests_GetBuildTypeWithInvestigations').should_not be_empty
      end

      it 'should return nil if no one is investigating' do
        @tc.buildtype_investigations('BuildTypeTests_GetBuildTypeWithNoInvestigations').should be_empty
      end
    end
  end

  describe 'PUT', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.set_buildtype_parameter' do
      it 'should set a buildtype parameter' do
        buildtype_id = 'BuildTypeTests_PutSetBuildTypeParameters'
        param_name = 'test-setting-buildtype-parameters'
        param_value = 'param-value'
        @tc.set_buildtype_parameter(buildtype_id, param_name, param_value).should eq(param_value)
      end
    end

    describe '.set_buildtype_field' do
      before(:each) do
        @buildtype_id = 'BuildTypeTests_PutSetBuildTypeField'
      end

      it 'should set the buildtype name' do
        field_name = 'name'
        field_value = 'PutSetBuildTypeField_Name_Changed_By_Test'
        @tc.set_buildtype_field(@buildtype_id, field_name, field_value).should eq(field_value)
      end

      it 'should set a projects description' do
        field_name = 'description'
        field_value = 'description-set_buildtype_field'
        @tc.set_buildtype_field(@buildtype_id, field_name, field_value).should eq(field_value)
      end

      it 'should pause a project' do
        field_name = 'paused'
        field_value = 'true'
        @tc.set_buildtype_field(@buildtype_id, field_name, field_value).should eq(field_value)
      end
    end

    describe '.set_buildtype_setting' do
      before(:each) do
        @buildtype_id = 'BuildTypeTests_PutSetBuildTypeSettings'
      end

      it 'should set if it should perform clean builds' do
        settings_name = 'cleanBuild'
        settings_value = 'true'
        @tc.set_buildtype_setting(@buildtype_id, settings_name, settings_value).should eq(settings_value)
      end

      it 'should set where the checkout happens when building' do
        settings_name = 'checkoutMode'
        settings_value = 'ON_AGENT'
        @tc.set_buildtype_setting(@buildtype_id, settings_name, settings_value).should eq(settings_value)
      end

      it 'should set what is the timeout in minutes when executing builds' do
        settings_name = 'executionTimeoutMin'
        settings_value = '10'
        @tc.set_buildtype_setting(@buildtype_id, settings_name, settings_value).should eq(settings_value)
      end
    end

    describe '.set_build_step_field' do
      before(:each) do
        @buildtype_id = 'BuildTypeTests_PutSetBuildStepField'
        @build_step_id = 'RUNNER_7'
      end

      it 'should disable a build step' do
        field_name = 'disabled'
        field_value = 'true'
        @tc.set_build_step_field(@buildtype_id, @build_step_id, field_name, field_value)
      end

      it 'should enable a build step' do
        field_name = 'disabled'
        field_value = 'false'
        @tc.set_build_step_field(@build_type_id, @build_step_id, field_name, field_value)
      end
    end
  end

  describe 'POST', :vcr do
    before(:all) do
      configure_client_with_authentication
    end

    before(:each) do
      @buildtype_id = 'BuildTypeTests_PostBuildTypeTests'
    end

    describe '.create_buildtype' do
      it 'should create a build type' do
        project_id = 'ProjectToTestBuildTypes'
        buildtype_name = 'PostCreateBuildType'
        buildtype_id = "#{project_id}_#{buildtype_name}"
        @tc.create_project(project_id)
        response = @tc.create_buildtype(project_id, buildtype_name)
        response.id.should eq(buildtype_id)
      end
    end

    describe '.create_buildtype' do
      it 'should create a build type with options' do
        project_id = 'ProjectToTestBuildTypes'
        buildtype_name = 'PostCreateBuildType'
        buildtype_id = "myBuildType_#{buildtype_name}"
        field_value = 'description-set_buildtype_field'

        @tc.create_project(project_id)
        response = @tc.create_buildtype_ex(project_id, buildtype_name, :id=>buildtype_id) do |properties|
          properties['description']=field_value
        end
        response.id.should eq(buildtype_id)
        response.description.should eq(field_value)
      end
    end

    describe '.attach_vcs_root' do
      it 'should attach a vcs root to a buildtype' do
        vcs_root_id = 'teamcity_ruby_client'
        @tc.attach_vcs_root(@buildtype_id, vcs_root_id).id.should eq(vcs_root_id)
      end
    end

    describe '.create_agent_requirement' do
      it 'should create an agent requirement for a buildtype' do
        parameter_name = 'post-agent-requirement-name'
        parameter_value = 'post-agent-requirement-value'
        condition = 'equals'
        args = [@buildtype_id, parameter_name, parameter_value, condition]
        response = @tc.create_agent_requirement(*args)
        response.id.should eq(parameter_name)
      end
    end

    describe '.create_build_step' do
      it 'should create a build step for a given build type' do
        response = @tc.create_build_step(@buildtype_id, name: 'Unit Tests', type: 'Maven') do |properties|
          properties['goals'] = 'verify'
          properties['mavenSelection'] = 'mavenSelection:default'
          properties['pomLocation'] = 'pom.xml'
        end
        response.name.should eq('Unit Tests')
      end
    end

    describe '.create_build_trigger' do
      it 'should create a build trigger for a given build type' do
        response = @tc.create_build_trigger(@buildtype_id, type: 'vcsTrigger') do |properties|
          properties['groupCheckkinsByCommitter'] = 'true'
          properties['perCheckinTriggering'] = 'true'
          properties['quietPeriodMode'] = 'DO_NOT_USE'
        end
        response.type.should eq('vcsTrigger')
      end
    end
  end

  describe 'DELETE', :vcr do
    before(:all) do
      configure_client_with_authentication
    end

    before(:each) do
      @buildtype_id = 'BuildTypeTests_DeleteBuildTypeSettings'
    end

    describe '.delete_buildtype_parameter' do
      it 'should delete a buildtype parameter' do
        param_to_delete = 'delete-buildtype-param'
        @tc.set_buildtype_parameter(@buildtype_id, param_to_delete, '')
        @tc.delete_buildtype_parameter(@buildtype_id, 'delete-me').should be_nil
      end
    end

    describe '.delete_agent_requirement' do
      it 'should delete the agent requirement' do
        agent_requirement_to_delete = 'delete-agent-requirement'
        @tc.create_agent_requirement(@buildtype_id, agent_requirement_to_delete, '', 'equals')
        @tc.delete_agent_requirement(@buildtype_id, agent_requirement_to_delete).should be_nil
      end
    end

    describe '.delete_buildtype' do
      it 'should delete a buildtype' do
        project_id_to_delete = 'BuildTypeTests_DeleteBuildTypeRequest'
        @tc.delete_buildtype(project_id_to_delete).should be_nil
      end
    end
  end
end
