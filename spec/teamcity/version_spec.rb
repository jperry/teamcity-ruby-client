require_relative '../spec_helper'

describe 'Version' do
  it 'should be defined' do
    TeamCity::VERSION.should match(/\d\.\d\.\d/)
  end
end