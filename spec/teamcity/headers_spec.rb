require File.expand_path('../../spec_helper', __FILE__)

describe TeamCity::Headers do

  def build_headers(*args)
    TeamCity::Headers.build(*args)
  end

  it "should default the accept header to json" do
    build_headers.accept.should eq("application/xml; charset=utf-8")
  end

  it "should default the content_type header to json" do
    build_headers.content_type.should eq("application/json")
  end

  it "should allow you to set the accept" do
    build_headers(:accept => :text).accept.should eq("text/plain")
  end

  it "should not set the content_type when setting accept" do
    build_headers(:accept => :text).content_type.should eq("application/json")
  end

  it "should allow you to set the content type" do
    build_headers(:content_type => :text).content_type.should eq("text/plain")
  end

  it "should not allow an invalid accept format" do
    expect { build_headers(:accept => :invalid) }.to raise_exception(ArgumentError)
  end

  it "should not allow an invalid content_type format" do
    expect { build_headers(:content_type => :invalid) }.to raise_exception(ArgumentError)
  end
end