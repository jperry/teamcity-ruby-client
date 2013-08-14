# The TeamCity Ruby Gem
[![Build Status](https://secure.travis-ci.org/jperry/teamcity-ruby-client.png?branch=master)](http://travis-ci.org/jperry/teamcity-ruby-client) [![Code Climate](https://codeclimate.com/github/jperry/teamcity-ruby-client.png)](https://codeclimate.com/github/jperry/teamcity-ruby-client) [![Dependency Status](https://gemnasium.com/jperry/teamcity-ruby-client.png)](https://gemnasium.com/jperry/teamcity-ruby-client)

Ruby wrapper for the TeamCity Rest API

## Installation

Add this line to your application's Gemfile:

    gem 'teamcity-ruby-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teamcity-ruby-client

## API Usage Examples

* Tested on TeamCity 8.0.2 and higher
    * There are no guarantees this works with TeamCity 7.X
    * Use the teamcity7 branch or gem version < 1.0.0
    * I'll be supporting teamcity7 for the next 6 months, please feel free to file tickets.
* Most of the api calls return either an array of Hashie::Mash objects or a single Hashie::Mash object which allows you to send messages to retreive an attribute easily.
* See [api docs](http://rubydoc.info/gems/teamcity-ruby-client/TeamCity/Client) or [specs](spec/teamcity/client) for additional examples and usage

### Configuration

* See [configuration](lib/teamcity/configuration.rb) source or api doc for more configuration options

```ruby
require 'teamcity'

# This only needs to be set once per Ruby execution.
# You may use guestAuth instead of httpAuth and omit the use of http_user and http_password
TeamCity.configure do |config|
  config.endpoint = 'http://my-teamcity-server:8111/httpAuth/app/rest'
  config.http_user = 'teamcity-user'
  config.http_password = 'teamcity-password'
end
```

### Projects

```ruby
# Get a list of projects
puts TeamCity.projects

# Get a project by id
puts TeamCity.project(id: 'project1')

# Get a list of buildtypes for a project
puts TeamCity.project_buildtypes(id: 'project1')

# Each item returned is a Hashie::Mash object which allows you to send messages
# to retreive an attribute easily.  For example, get the name of
# the first buildtype in a project
puts TeamCity.project_buildtypes(id: 'project1').first.name

# Create an empty project
TeamCity.create_project('my-new-project')

# Copy a project
TeamCity.copy_project('project1', 'copied-project-name')

# Delete a project
TeamCity.delete_project('project1')

# Change project name
TeamCity.set_project_field('project1', 'name', 'new-project-name')
```

### Build Types (Build Configurations)

```ruby
# Get a list of buildtypes (build configurations)
puts TeamCity.buildtypes

# Get buildtype details (build configuration)
puts TeamCity.buildtype(id: 'bt1')

# Get buildtype steps
puts TeamCity.buildtype_steps(id: 'bt1')

# Change buildtype name
TeamCity.set_buildtype_field('bt1', 'name', 'new-buildtype-name')
```

### Builds ###

```ruby
# Get build details
puts TeamCity.build(id: 1)

# Get build tags
puts TeamCity.build_tags(id: 1)

# Fetch all the builds (defaults to the last 100 builds, use the 'count' build locator to return more)
puts TeamCity.builds

# Filter builds by multiple criteria's using the build locator
puts TeamCity.builds(count: 1, status: 'SUCCESS') # This will return the most recent build that passed

puts TeamCity.builds(count: 1).first.name

puts TeamCity.builds(buildType: 'bt3') # Fetch all builds where buildType=bt4

puts TeamCity.builds(status: 'FAILURE') # Fetch all builds that failed

# Passing the output to another to fetch additional information
puts TeamCity.build(id: TeamCity.builds(count: 1).first.id).buildType.name # Fetch the name of the last build to run

```

### VCS Roots ###

```ruby
# Get all the vcs roots
puts Teamcity.vcs_roots

# Get vcs root details
puts TeamCity.vcs_root_details(1)

# Create VCS Root for a project
TeamCity.create_vcs_root(vcs_name: 'my-git-vcs-root', vcs_type: 'git', :project_id => 'project2') do |properties|
  properties['branch'] = 'master'
  properties['url'] = 'git@github.com:jperry/teamcity-ruby-client.git'
  properties['authMethod'] = 'PRIVATE_KEY_DEFAULT'
  properties['ignoreKnownHosts'] = true
end

```

## Documentation

### API Docs

[Latest](http://rubydoc.info/gems/teamcity-ruby-client/)

### Generating API Docs

1. Pull the source down
2. ```bundle install```
3. ```rake yard```
4. open doc/index.html

### TeamCity Rest API Plugin

[Link](http://confluence.jetbrains.com/display/TW/REST+API+Plugin)

## Contributing

Ways to contribute:

* report a bug
* fix an issue that is logged
* suggest enhancements
* suggest a new feature
* cleaning up code
* refactoring code
* fix documentation errors
* test on a new versions of teamcity
* Use the gem :)

## Submitting an issue

I use issue tracker to track bugs, features, enhancements, etc.  Please check the list of issues to confirm
it hasn't already been reported.  Please tag the the issue with an appropriate tag.  If submitting a bug please
include any output that will help me in diagnosing the issue, link to a gist if you have multiple outputs 
(client output, teamcity server output).  Please include the version of teamcity you are using
the client against as well as the gem and ruby versions.

## Submitting a Pull Request

1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run ```rake doc:yard```. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. If the rspec test is making a request use VCR to record the response, see the other examples.
7. Run ```rake spec```. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request.

## Debugging Tips

* Enable debug-rest in TeamCity to see all the rest api requests come through in the `teamcity-rest.log`, you can find this on the Diagnostics page under Server Administration

## Questions/Comments

Feel free to contact me directly through github.  Enjoy!
