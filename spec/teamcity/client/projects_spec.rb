require_relative '../../spec_helper'

describe 'Projects' do
  it 'should fetch projects' do
    pending 'need to plugin vcr and webmock' do
      TeamCity.configure do |config|
        config.endpoint = 'http://localhost:8111/guestAuth/app/rest/7.0/'
      end
      TeamCity.projects.should_not be_nil
    end
  end
end