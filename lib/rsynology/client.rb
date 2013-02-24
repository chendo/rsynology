require 'faraday'
require 'faraday_middleware'

module RSynology
  class Client
    attr_reader :connection
    attr_accessor :session_id

    class RequestFailed < StandardError; end

    def initialize(url, options = {})
      faraday_options = {url: url}
      faraday_options[:ssl] = {verify: false} if options[:verify_ssl] == false

      @connection = Faraday.new(faraday_options) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.use FaradayMiddleware::ParseJson
        faraday.use FaradayMiddleware::Mashify
      end
    end

    def login!(account, password, session = nil, format = 'sid')
      endpoints['SYNO.API.Auth'].login(account, password, session, format)
    end

    def endpoints
      # Returns a hash of endpoints. Will return nil if no support
      resp = request('query.cgi', {
        api: 'SYNO.API.Info',
        method: 'Query',
        version: 1,
        query: 'SYNO.'
      })
      {}.tap do |result|
        resp['data'].each do |endpoint, options|
          next unless supported_apis[endpoint]
          result[endpoint] = supported_apis[endpoint].new(self, options)
        end
      end
    end

    def request(endpoint, params)
      params = params.merge(sid: session_id) if session_id
      resp = connection.get("/webapi/#{endpoint}", params)
      resp.body
    end

    private

    def supported_apis
      @supported_apis ||= {}.tap do |apis|
        self.class.constants.each do |symbol|
          next if symbol == :API
          const = self.class.const_get(symbol)
          if const.respond_to?(:api_name)
            apis[const.api_name] = const
          end
        end
      end
    end
  end
end
