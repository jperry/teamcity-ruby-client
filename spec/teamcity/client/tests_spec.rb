require_relative '../../spec_helper'

describe 'Tests' do

  before(:each) do
    @tc = TeamCity
    # configure_client_with_authentication_apm
    configure_client_with_authentication
  end

  # Get requests
  describe 'GET', :vcr do

    describe '.tests' do
      it 'should fetch all the tests' do
        tests = @tc.tests(build: 2614725)
        tests.should have(9).items
      end

      it 'should allow you to filter results by test count locator' do
        @tc.tests(build: 2614725, count:1).should have(1).items
      end

      it 'should allow you to filter by test id' do
        @tc.tests(build: 2614725, id: 143).should have(1).items
      end

      it 'should return an empty array if no test is found' do
        tests = @tc.tests(build: 2614725, id: 1433333)
        tests.should be_empty
        tests.class.should == Array
      end

      it 'should return an empty array if no build is found' do
        tests = @tc.tests(build: 9999999)
        tests.should be_empty
        tests.class.should == Array
      end

      it 'should return an empty array if not build is given' do
        tests = @tc.tests
        tests.should be_empty
        tests.class.should == Array
      end
    end
  end
end
