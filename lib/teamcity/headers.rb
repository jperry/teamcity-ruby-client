module TeamCity
  class Headers

    VALID_FORMATS = [ :json, :xml, :text ]

    def self.generate_for(format)
      raise ArgumentError unless VALID_FORMATS.include?(format)
      self.const_get(format.to_s.upcase).new
    end

    private

    class HeaderDefinitions
      def to_s
        name
      end

      def name
        self.class.name.split('::').last.downcase
      end
    end

    class XML < HeaderDefinitions
      def accept; 'application/xml'; end
      def content_type; 'application/json'; end
    end

    class JSON < HeaderDefinitions
      def accept; 'application/json'; end
      def content_type; 'application/json'; end
    end

    class TEXT < HeaderDefinitions
      def accept; 'text/plain'; end
      def content_type; 'text/plain'; end
    end
  end
end