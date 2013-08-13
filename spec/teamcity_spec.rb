require "spec_helper.rb"

describe TeamCity do
  after do
    TeamCity.reset
  end

  context "when delegating to a client" do
    before(:each) do
      @url = "#{TeamCity::Configuration::DEFAULT_ENDPOINT}projects/id:project1"
      stub_request(:get, @url).to_return(:body => "", :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      VCR.turned_off do
        TeamCity.project(id: "project1")
        a_request(:get, @url).should have_been_made
      end
    end
  end

  describe ".client" do
    it "should be a TeamCity::Client" do
      TeamCity.client.should be_a TeamCity::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      TeamCity.adapter.should == TeamCity::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      TeamCity.adapter = :faraday
      TeamCity.adapter.should == :faraday
    end
  end

  describe ".http_user" do
    it "should return the default http_user" do
      TeamCity.http_user.should == TeamCity::Configuration::DEFAULT_HTTP_USER
    end
  end

  describe ".http_user=" do
    it "should set the http_user" do
      TeamCity.http_user = 'test-user'
      TeamCity.http_user.should == 'test-user'
    end
  end

  describe ".http_password" do
    it "should return the default http_password" do
      TeamCity.http_password.should == TeamCity::Configuration::DEFAULT_HTTP_PASSWORD
    end
  end

  describe ".http_password=" do
    it "should set the http_password" do
      TeamCity.http_password = 'test-pass'
      TeamCity.http_password.should == 'test-pass'
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      TeamCity.endpoint.should == TeamCity::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      TeamCity.endpoint = "http://teamcity.mydomain.net:8111"
      TeamCity.endpoint.should == "http://teamcity.mydomain.net:8111"
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      TeamCity.user_agent.should == TeamCity::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      TeamCity.user_agent = "My User Agent"
      TeamCity.user_agent.should == "My User Agent"
    end
  end

  describe ".configure" do
    TeamCity::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        TeamCity.configure do |config|
          config.send("#{key}=", key)
          TeamCity.send(key).should == key
        end
      end
    end
  end
end