module TeamCity
  class ElementBuilder
    def initialize(element, attributes = {}, &block)
      @builder = Builder::XmlMarkup.new
      @builder.tag!(element.to_sym, attributes) do |node|
        node.properties do |p|
          if block_given?
            properties = {}
            yield(properties)
            properties.each do |name, value|
              p.property(:name => name, :value => value)
            end
          end
        end
      end
    end

    def to_request_body
      @builder.target!
    end
  end
end
