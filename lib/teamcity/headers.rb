module TeamCity
  class Headers

    VALID_FORMATS = [ :json, :xml, :text ]

    def self.build(opts={})
      accept_format = opts.fetch(:accept){ :json }
      content_type_format = opts.fetch(:content_type){ :json }
      raise ArgumentError, "Invalid format for :accept, valid formats: #{VALID_FORMATS}" unless VALID_FORMATS.include?(accept_format)
      raise ArgumentError, "Invalid format for :content_type, valid format: #{VALID_FORMATS}" unless VALID_FORMATS.include?(content_type_format)
      new do |headers|
        headers.accept = self.const_get(accept_format.to_s.capitalize).accept
        headers.content_type = self.const_get(content_type_format.to_s.capitalize).content_type
      end
    end

    attr_accessor :accept, :content_type

    def initialize
      yield(self) if block_given?
    end

    def to_hash
      {
        'Accept' => accept,
        'Content-Type' => content_type
      }
    end

    private

    class Xml
      def self.accept; "application/xml; charset=utf-8"; end
      def self.content_type; "application/xml"; end
    end

    class Json
      def self.accept; "application/json; charset=utf-8"; end
      def self.content_type; "application/json"; end
    end

    class Text
      def self.accept; 'text/plain'; end
      def self.content_type; 'text/plain'; end
    end
  end
end