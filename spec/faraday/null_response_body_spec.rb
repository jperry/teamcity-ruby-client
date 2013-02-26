require "spec_helper.rb"

describe 'FaradayMiddleware' do
  describe 'NullResponseBody' do

    before(:each) do
      @url = "#{TeamCity::Configuration::DEFAULT_ENDPOINT}projects"
    end

    it "should return empty hash if the body is 'null'" do
      stub_request(:get, @url).to_return(:body => "null", :headers => {:content_type => "application/json; charset=utf-8"})
      VCR.turned_off do
        results = TeamCity.get('projects')
        results.should be_empty
      end
    end
  end
end