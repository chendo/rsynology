module RSynology
  class Client
    class API
      attr_reader :client, :options, :endpoint, :minVersion, :maxVersion

      def self.api_name
        raise NotImplementedError
      end

      def initialize(client, options)
        @client = client
        @options = options
        @endpoint = options['path']
        @minVersion = options['minVersion']
        @maxVersion = options['maxVersion']
      end

      def api_name
        self.class.api_name
      end

      def request(method, params, version = maxVersion)
        params = {
          method: method,
          version: maxVersion,
          api: api_name
        }.merge(params)
        client.request(endpoint, params)
      end
    end
  end
end
