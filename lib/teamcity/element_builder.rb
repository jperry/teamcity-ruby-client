module TeamCity
  class ElementBuilder
    def initialize(element, attributes = {}, &block)
      @payload = attributes

      @payload['properties'] ||= {}
      @payload['properties']['property'] ||= []

      if block_given?
        properties = {}

        yield(properties)

        properties.each do |name, value|
          @payload['properties']['property'] << {
            :name  => name,
            :value => value
          }
        end
      end
    end

    def to_request_body
      @payload.to_json
    end
  end
end
