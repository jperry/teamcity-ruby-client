require_relative 'teamcity/configuration'
require_relative 'teamcity/client'
require_relative 'teamcity/headers'

module TeamCity
  extend Configuration

  # Alias for TeamCity::Client.new
  #
  # @return [TeamCity::Client]
  def self.client(options={})
    TeamCity::Client.new(options)
  end

  # Delegate to TeamCity::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to TeamCity::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end
