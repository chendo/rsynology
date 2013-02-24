require 'faraday'
require 'faraday_middleware'

module RSynology
  class Client
    attr_reader :connection
    attr_accessor :session_id

    class RequestFailed < StandardError; end

    SUPPORTED_ENDPOINTS = {
      'SYNO.API.Auth' => 'Auth'
    }

    def initialize(url)
      @connection = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.use FaradayMiddleware::ParseJson
        faraday.use FaradayMiddleware::Mashify
      end
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
        resp.each do |endpoint, options|
          next unless SUPPORTED_ENDPOINTS[endpoint]
          result[endpoint] = self.class.const_get(SUPPORTED_ENDPOINTS[endpoint]).new(self, options)
        end
      end
    end

    def request(endpoint, params)
      params = params.merge(sid: session_id) if session_id
      resp = connection.get("/webapi/#{endpoint}", params)
      body = resp.body
      if !body['success']
        raise RequestFailed
      end
      body['data']
    end
  end
end
