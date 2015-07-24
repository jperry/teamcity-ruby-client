module TeamCity
  class Client
    # Defines methods related to build queues in TeamCity
    module BuildQueue
      # HTTP GET

      # List of all queued builds
      #
      # @return [Array<Hashie::Mash>, nil] of queued_builds or nil if no queued_builds exist
      def queued_builds
        response = get('buildQueue')
        response['build']
      end

      # HTTP GET

      # List of queued builds with locator filters
      #
      # @param options [Hash] list of build locators to filter build results
      # @return [Array<Hashie::Mash>, nil] of queued builds (empty array if no builds exist)
      def queued(options={})
        url_params = options.empty? ? '' : "?locator=#{locator(options)}"
        response = get("buildQueue#{url_params}")
        response['build']
      end

      # HTTP GET
      #
      # Get the number of builds currently in the queue.
      # @return String indicating the number of builds currently queued
      def queued_build_count
        response = get('buildQueue')
        response.count
      end

      # HTTP GET

      # Show queued build details
      #
      # @param options [Hash] list of build locators to filter build results on
      # @return <Hashie::Mash> of queued build details
      def queued_build_details(task_id)
        response = get("buildQueue/taskId:#{task_id}")
        response
      end

      # HTTP GET

      # Show compatible agents for queued builds
      #
      # @param task_id build task ID for the queued build
      # @return [Array<Hashie::Mash>, nil] of compatible build agents with details
      def queued_build_compatible_agents(task_id)
        response = get("buildQueue/taskId:#{task_id}/compatibleAgents")
        response
      end


    end
  end
end