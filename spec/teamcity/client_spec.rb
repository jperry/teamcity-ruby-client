require_relative '../spec_helper'

describe TeamCity::Client do
  before(:each) do
    configure_client_with_authentication
  end

  it "should connect using the endpoint configuration" do
    client = TeamCity::Client.new
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    connection.should eq(endpoint.to_s)
  end
end
