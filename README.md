# The TeamCity Ruby Gem [![Build Status](https://secure.travis-ci.org/jperry/teamcity-ruby-client.png?branch=master)](http://travis-ci.org/jperry/teamcity-ruby-client) [![Code Climate](https://codeclimate.com/github/jperry/teamcity-ruby-client.png)](https://codeclimate.com/github/jperry/teamcity-ruby-client) [![Dependency Status](https://gemnasium.com/jperry/teamcity-ruby-client.png)](https://gemnasium.com/jperry/teamcity-ruby-client)

Ruby wrapper for the TeamCity Rest API

## Installation

Add this line to your application's Gemfile:

    gem 'teamcity-ruby-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teamcity-ruby-client

## API Usage Examples

* Tested on TeamCity 7.0 and higher
* See the spec tests for more examples

### Configuration

```ruby
require 'teamcity'

# Currently only guest authentication is supported, next version will
# support authentication which will allow write api calls.  Use this
# with all the other calls below.
TeamCity.configure do |config|
  config.endpoint = 'http://teamcity:8111/guestAuth/app/rest'
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
```

### Build Types (Build Configurations)

```ruby
# Get a list of buildtypes (build configurations)
puts TeamCity.buildtypes

# Get buildtype details (build configuration)
puts TeamCity.buildtype(id: 'bt1')

# Get buildtype steps
puts TeamCity.buildtype_steps(id: 'bt1')

# See the api docs for more api calls
```

### Builds ###

```ruby
# Get build details
puts TeamCity.build(id: 1)

# Get build tags
puts TeamCity.build_tags(id: 1)

# Get all builds
puts TeamCity.builds

# Filter builds by multiple criteria's using the build locator
puts TeamCity.builds(count: 2, status: 'SUCCESS') # This will return 2 builds where status=SUCCESS

puts TeamCity.builds(buildType: 'bt3') # Fetch all builds where buildType=bt4

puts TeamCity.builds(status: 'FAILURE') # Fetch all builds that failed

```

## Documentation

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
