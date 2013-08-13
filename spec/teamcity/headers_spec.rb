require File.expand_path('../../spec_helper', __FILE__)

describe TeamCity::Headers do

  before(:each) do
    @klass = TeamCity::Headers
  end

  it "should not accept an invalid format" do
    expect { @klass.generate_for(:invalid_format) }.to raise_exception(ArgumentError)
  end

  it "should provide the accept header for json" do
    headers = @klass.generate_for(:json)
    headers.accept.should eq("application/json")
  end

  it "should provide the content_type header for json" do
    headers = @klass.generate_for(:json)
    headers.content_type.should eq("application/json")
  end

  it "should provide the accept header for xml" do
    headers = @klass.generate_for(:xml)
    headers.accept.should eq("application/xml")
  end

  it "should provide the content_type header for xml" do
    headers = @klass.generate_for(:xml)
    headers.content_type.should eq("application/json")
  end

  it "should provide the accept header for text" do
    headers = @klass.generate_for(:text)
    headers.accept.should eq("text/plain")
  end

  it "should provide the conten_type header for text" do
    headers = @klass.generate_for(:text)
    headers.content_type.should eq("text/plain")
  end
end