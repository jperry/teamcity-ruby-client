require File.expand_path('../../spec_helper', __FILE__)

describe TeamCity::ElementBuilder do
  it 'outputs xml following TeamCity convention for elements and properties' do
    builder = TeamCity::ElementBuilder.new('some_element', :attr1 => 'x') do |properties|
      properties['property1'] = 'z'
    end

    builder.to_request_body.should ==
      '<some_element attr1="x"><properties><property name="property1" value="z"/></properties></some_element>'
  end

  it 'outputs xml following TeamCity convention for elements even if no properties are defined' do
    builder = TeamCity::ElementBuilder.new('some_element', :attr1 => 'x')

    builder.to_request_body.should ==
      '<some_element attr1="x"><properties></properties></some_element>'
  end
end
