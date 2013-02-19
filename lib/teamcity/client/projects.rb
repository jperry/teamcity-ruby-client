module TeamCity
  class Client
    # Defines methods related to projects
    module Projects
      def projects(options={})
        response = get('projects', options)
        response['project']
      end
    end
  end
end