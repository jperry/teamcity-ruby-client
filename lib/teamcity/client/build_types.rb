module TeamCity
  class Client
    # Defines methods related to build types (or build configurations)
    module BuildTypes

      # HTTP GET

      # List of build types
      #
      # @return [Array<Hashie::Mash>, nil] of buildtypes or nil if no buildtypes exist
      def buildtypes
        response = get('buildTypes')
        response['buildType']
      end
    end
  end
end