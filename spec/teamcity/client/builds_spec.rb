require_relative '../../spec_helper'

describe 'Builds' do

  before(:each) do
    @tc = TeamCity
    configure_client_with_authentication
  end

  # Get requests
  describe 'GET', :vcr do

    before(:each) do
      @buildtype_id = 'BuildTests_GetBuildTests'
    end

    describe '.builds' do
      it 'should fetch all the builds' do
        builds = @tc.builds
        builds.should have_at_least(1).items
      end

      it 'should allow you to filter results by build locators' do
        @tc.builds(count:1).should have(1).items
      end

      it 'should allow you to filter by multiple build locators' do
        @tc.builds(count: 2, status: 'SUCCESS').should have(2).items
      end

      it 'should return an empty array if no results are found' do
        @tc.builds(tags: 'return-empty-result').should be_empty
      end
    end

    describe '.build' do
      it 'should fetch the build details' do
        build_id = @tc.builds.first.id
        @tc.build(id: build_id).id.should eq(build_id)
      end

      it 'should raise an error if the build does not exist' do
        expect { @tc.build(id: 'doesnotexist') }.to raise_error
      end

      it 'should raise an error if an id is not provided' do
        expect { @tc.build }.to raise_exception(ArgumentError)
      end
    end

    describe '.build_tags' do
      it 'should fetch the build tags' do
        build = @tc.builds(tags: 'tag-test').first
        tags = @tc.build_tags(id: build.id)
        tags.should include('tag-test')
      end

      it 'should return an empty array if there are no build tags defined for a build' do
        build = @tc.builds.first
        @tc.build_tags(id: build.id).should be_empty
      end
    end

    describe '.build_pinned?', :vcr do
      it 'should return true when a build is pinned' do
        build_to_pin = @tc.builds.first
        @tc.pin_build(build_to_pin.id)
        @tc.build_pinned?(build_to_pin.id).should be_true
      end

      it 'should return false when a build is not pinned' do
        build_to_unpin = @tc.builds.first
        @tc.unpin_build(build_to_unpin.id)
        @tc.build_pinned?(build_to_unpin.id).should be_false
      end
    end

    describe '.build_statistics' do
      it 'should return statistics for a build' do
        build = @tc.builds.first
        results = @tc.build_statistics(build.id)
        results.should have_at_least(1).items
      end

      it 'should return statistics for a build type' do
        build = @tc.builds.first
        results = @tc.build_statistics_for_build_type(build.buildTypeId)
        results.should have_at_least(1).items
      end
    end

    describe '.build_artifacts' do
      it 'should fetch all the artifacts' do
        build = @tc.builds.first
        artifacts = @tc.build_artifacts(build.id)     
        artifacts.should have_at_least(2).items
      end
    end
  end

  describe 'PUT', :vcr do
    describe '.pin_build' do
      it 'should pin a build' do
        build_to_pin = @tc.builds.first
        comment = 'this will add a comment'
        @tc.pin_build(build_to_pin.id, comment).should be_nil
      end
    end
  end

  describe 'DELETE', :vcr do
    describe '.unpin_build' do
      it 'should unpin a build' do
        build_to_unpin = @tc.builds.first
        @tc.unpin_build(build_to_unpin.id).should be_nil
      end
    end
  end
end
