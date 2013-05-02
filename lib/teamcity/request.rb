module TeamCity
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, &block)
      request(:get, path, options, &block)
    end

    # Perform an HTTP POST request
    def post(path, options={}, &block)
      request(:post, path, options, &block)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, &block)
      request(:put, path, options, &block)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, &block)
      request(:delete, path, options, &block)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, &block)
      response = connection.send(method) do |request|
        block.call(request) if block_given?
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = options unless options.empty?
        end
      end
      response.body
    end
  end
end