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

    describe '.buildtypes' do

      it 'should fetch all the buildtypes', :vcr do
        @tc.buildtypes.size.should eq(3)
      end

    end

    describe '.buildtype' do

      it 'should fetch the details of a buildtype by id', :vcr do
        @tc.buildtype(id: 'bt2').id.should eq('bt2')
      end

      it 'should raise an error if the buildtype does not exist', :vcr do
        expect { @tc.buildtype(id: 'missing') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.buildtype }.to raise_error
      end
    end

    describe '.buildtype_state' do
      it 'should fetch the state of the buildtype', :vcr do
        pending "bug in rest api plugin"
        @tc.buildtype_state(id: 'bt2')
      end
    end

    describe '.buildtype_settings' do
      it 'should fetch the settings for a given buildtype', :vcr do
        @tc.buildtype_settings(id: 'bt2').should_not be_empty
      end

      it 'should return an array', :vcr do
        @tc.buildtype_settings(id: 'bt2').should be_kind_of(Array)
      end
    end

    describe '.buildtype_parameters' do
      it 'should fetch the parameters for a given buildtype', :vcr do
        @tc.buildtype_parameters(id: 'bt2').should_not be_empty
      end

      it 'should return an array', :vcr do
        @tc.buildtype_parameters(id: 'bt2').should be_kind_of(Array)
      end

      it 'should return nil if there are no parameters defined', :vcr do
        @tc.buildtype_parameters(id: 'bt3').should be_nil
      end
    end

    [
      :steps,
      :features,
      :triggers,
      :agent_requirements,
      :snapshot_dependencies,
      :artifact_dependencies
    ].each do |type|
      describe ".buildtype_#{type}" do

        before(:each) do
          @method_name = "buildtype_#{type}"
        end

        it "should fetch the build configuration #{type} for a buildtype", :vcr do
          @tc.send(@method_name, id: 'bt2').size.should eq(1)
        end

        it 'should return an array', :vcr do
          @tc.send(@method_name, id: 'bt2').should be_kind_of(Array)
        end

        it "should return nil if there are no #{type} defined", :vcr do
          @tc.send(@method_name, id: 'bt3').should be_nil
        end
      end
    end
  end
end