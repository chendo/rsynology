module RSynology
  class Client
    class Auth
      attr_reader :client, :endpoint

      def initialize(client, options)
        @client = client
        @endpoint = options['path']
      end

      def login(account, password, session = nil, format = 'sid')
        params = {
          account: account,
          passwd: password,
          format: format
        }
        params.merge!(session: session) if session

        response = client.request(endpoint, params)
        client.session_id = response['sid']
      end

      def logout(session)
        client.request(endpoint, {session: session})
      end
    end
  end
end
