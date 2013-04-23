require_relative '../../spec_helper'

describe 'Builds' do

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

    describe '.builds' do
      it 'should fetch all the builds' do
        @tc.builds.size.should eq(4)
      end

      it 'should allow you to filter results by build locators' do
        @tc.builds(count:2).size.should eq(2)
      end

      it 'should allow you to filter by multiple build locators' do
        @tc.builds(count: 2, status: 'SUCCESS').size.should eq(2)
      end
    end

    describe '.build' do
      it 'should fetch the build details' do
        @tc.build(id: 2).id.should eq(2)
      end

      it 'should raise an error if the build does not exist' do
        expect { @tc.build(id: '10000') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.build }.to raise_error
      end
    end

    describe '.build_tags' do
      it 'should fetch the build tags' do
        tags = @tc.build_tags(id: 2)
        tags.size.should eq(1)
        tags.first.should eq('release_tag')
      end

      it 'should return nil if there are no build tags defined for a build' do
        @tc.build_tags(id: 1).should be_nil
      end
    end
  end
end