module RSynology
  class Client::Auth
    attr_reader :client, :options

    def initialize(client, options)
      @client = client
      @endpoint = options['path']
    end
  end
end
