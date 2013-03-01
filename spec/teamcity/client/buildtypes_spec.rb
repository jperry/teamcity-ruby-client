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

  end
end