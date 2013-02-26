module RSynology
  class Client
    class Auth < API
      attr_reader :client, :endpoint, :maxVersion

      class AuthenticationFailed < StandardError; end

      def self.api_name
        'SYNO.API.Auth'
      end

      def login(account, password, session = nil, format = 'sid')
        params = {
          account: account,
          passwd: password,
          format: format,
        }
        params.merge!(session: session) if session

        response = request("Login", params)

        raise AuthenticationFailed if !response['success']

        client.session_id = response['data']['sid']
      end

      def logout(session)
        client.request(endpoint, {session: session})
      end

      protected

      class AccountNotSpecified < ArgumentError; end
      class InvalidPassword < StandardError; end
      class AccountDisabledOrGuest < StandardError; end

      def handle_error(error)
        case error['code']
        when 101
          raise AccountNotSpecified
        when 400
          raise InvalidPassword
        when 401
          raise AccountDisabledOrGuest
        end
        super
      end
    end
  end
end
