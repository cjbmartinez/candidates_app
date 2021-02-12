module Talkpush
  class Client
    HTTP_CONNECT_TIMEOUT = 22
    HTTP_WRITE_TIMEOUT = 22
    HTTP_READ_TIMEOUT = 22
    ROOT_API_URL = "https://my.talkpush.com/api/talkpush_services".freeze

    def call(method:, path:, json: {}, params: {}, headers: {})
      request = http.headers(headers)
                     .method(method)
                     .call(build_url(path), json: json, params: params)
      response = request.parse
      raise Talkpush::RequestError, response['message'] unless request.status.success?

      response
    rescue HTTP::Error => e
      raise Talkpush::RequestError, e.message
    end

    private

    def headers
      {
        'Cache-Control' => 'no-chace',
        'Content-Type' => 'application/json'
      }
    end

    def build_url(path)
      [ROOT_API_URL, path].join('/')
    end

    def http
      @http ||= begin
        client = HTTP.timeout(connect: HTTP_CONNECT_TIMEOUT, write: HTTP_WRITE_TIMEOUT, read: HTTP_READ_TIMEOUT)
        client = client.use(logging: { logger: Rails.logger }) unless Rails.env.test?
        client
      end
    end
  end
end
