require File.expand_path('../../spec_helper', __FILE__)

describe TeamCity::API do
  before do
    @keys = TeamCity::Configuration::VALID_OPTIONS_KEYS
  end

  context "with module configuration" do

    before do
      TeamCity.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      TeamCity.reset
    end

    it "should inherit module configuration" do
      api = TeamCity::API.new
      @keys.each do |key|
        api.send(key).should == key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :adapter => :excon,
          :endpoint => 'http://teamcity.mydomain.com/',
          :user_agent => 'My User Agent',
          :http_user => 'tc-test-user',
          :http_password => 'tc-test-password'
        }
      end

      context "during initialization"

        it "should override module configuration" do
          api = TeamCity::API.new(@configuration)
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end

      context "after initilization" do

        it "should override module configuration after initialization" do
          api = TeamCity::API.new
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end
      end
    end
  end
end
