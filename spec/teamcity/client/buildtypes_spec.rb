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
  describe 'GET', :vcr do

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
          @tc.send(@method_name, id: 'bt3').should be_nil
        end
      end
    end
  end
end