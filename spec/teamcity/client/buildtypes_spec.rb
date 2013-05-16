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

    before(:all) do
      TeamCity.configure do |config|
        config.endpoint = 'http://localhost:8111/guestAuth/app/rest/7.0/'
      end
    end

    before(:each) do
      @tc = TeamCity
    end

    describe '.buildtypes' do

      it 'should fetch all the buildtypes' do
        @tc.buildtypes.size.should eq(3)
      end

    end

    describe '.buildtype' do

      it 'should fetch the details of a buildtype by id' do
        @tc.buildtype(id: 'bt2').id.should eq('bt2')
      end

      it 'should raise an error if the buildtype does not exist' do
        expect { @tc.buildtype(id: 'missing') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.buildtype }.to raise_error
      end
    end

    describe '.buildtype_state' do
      it 'should fetch the state of the buildtype' do
        pending "bug in rest api plugin"
        @tc.buildtype_state(id: 'bt2')
      end
    end

    describe '.buildtype_settings' do
      it 'should fetch the settings for a given buildtype' do
        @tc.buildtype_settings(id: 'bt2').should have_at_least(1).items
      end

      it 'should return an array' do
        @tc.buildtype_settings(id: 'bt2').should be_kind_of(Array)
      end
    end

    describe '.buildtype_template' do
      it 'should return the attributes of the associated template' do
        @tc.buildtype_template(id: 'bt2').id.should_not be_nil
      end

      it 'should return nil if the buildtype is not associated with a template' do
        @tc.buildtype_template(id: 'bt3').should be_nil
      end

      it 'should raise an exception if the response is not due to a template not assigned' do
        expect { @tc.buildtype_template(id: 'bt500').should be_nil }.to raise_error
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
        end

          it "should fetch the build configuration #{type} for a buildtype" do
          @tc.send(@method_name, id: 'bt2').should have_at_least(1).items
        end

        it 'should return an array' do
          @tc.send(@method_name, id: 'bt2').should be_kind_of(Array)
        end

        it "should return nil if there are no #{type} defined" do
          @tc.send(@method_name, id: 'bt4').should be_nil
        end
      end
    end
  end

  describe 'PUT', :vcr do

    before(:all) do
      configure_client_with_authentication
    end

    describe '.set_buildtype_parameter' do
      it 'should set a buildtype parameter' do
        @tc.set_buildtype_parameter('bt3', 'set-this-parameter', 'some-value').should be_nil
      end
    end

    describe '.set_buildtype_field' do
      it 'should set the buildtype name' do
        @tc.set_buildtype_field('bt3', 'name', 'new-buildtype-name').should be_nil
      end

      it 'should set a projects description' do
        @tc.set_buildtype_field('bt3', 'description', 'description-changed-by-test').should be_nil
      end

      it 'should pause a project' do
        @tc.set_buildtype_field('bt3', 'paused', 'true').should be_nil
      end
    end
  end

  describe 'POST', :vcr do
    before(:all) do
      configure_client_with_authentication
    end

    describe '.attach_vcs_root' do
      it 'should attach a vcs root to a buildtype' do
        @tc.attach_vcs_root('bt3', '1').id.should eq('1')
      end
    end

    describe '.create_agent_requirement' do
      it 'should create an agent requirement for a buildtype' do
        buildtype_id = 'bt3'
        parameter_name = 'test'
        parameter_value = 'test'
        condition = 'equals'
        args = [buildtype_id, parameter_name, parameter_value, condition]
        response = @tc.create_agent_requirement(*args)
        response.id.should eq('test')
      end
    end
  end

  describe 'DELETE', :vcr do
    before(:all) do
      configure_client_with_authentication
    end

    describe '.delete_buildtype_parameter' do
      it 'should delete a buildtype parameter' do
        @tc.delete_buildtype_parameter('bt3', 'delete-me').should be_nil
      end
    end

    describe '.delete_agent_requirement' do
      it 'should delete the agent requirement' do
        @tc.delete_agent_requirement('bt3', 'test').should be_nil
      end
    end

    describe '.delete_buildtype' do
      it 'should delete a buildtype' do
        @tc.delete_buildtype('bt8').should be_nil
      end
    end
  end
end