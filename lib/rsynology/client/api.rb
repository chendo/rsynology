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

      protected

      class UnknownError < StandardError; end
      class InvalidParameters < ArgumentError; end
      class APINotFound < ArgumentError; end
      class MethodNotFound < ArgumentError; end
      class APIVersionNotSupported < ArgumentError; end
      class AccessDenied < StandardError; end
      class ConnectionTimedOut < StandardError; end
      class MultipleLoginsDetected < StandardError; end
      class UnhandledErrorCode < StandardError; end

      def handle_response(response)
        if response['success']
          response['data']
        else
          handle_error(response['error'])
        end
      end

      def handle_error(error)
        error_code = error['code']
        case error_code
        when 100
          raise UnknownError
        when 101
          raise InvalidParameters
        when 102
          raise APINotFound
        when 103
          raise MethodNotFound
        when 104
          raise APIVersionNotSupported
        when 105
          raise AccessDenied
        when 106
          raise ConnectionTimedOut
        when 107
          raise MultipleLoginsDetected
        else
          raise UnhandledErrorCode, error_code
        end
      end
    end
  end
end
