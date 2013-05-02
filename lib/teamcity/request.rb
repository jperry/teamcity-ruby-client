module TeamCity
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, &block)
      request(:get, path, &block)
    end

    # Perform an HTTP POST request
    def post(path, &block)
      request(:post, path, &block)
    end

    # Perform an HTTP PUT request
    def put(path, &block)
      request(:put, path, &block)
    end

    # Perform an HTTP DELETE request
    def delete(path, &block)
      request(:delete, path, &block)
    end

    private

    # Perform an HTTP request
    def request(method, path, &block)
      response = connection.send(method) do |request|
        block.call(request) if block_given?
        request.url(path)
      end
      response.body
    end
  end
end