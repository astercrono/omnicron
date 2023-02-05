require "net/http"
require "json"
require_relative "../model/http_models"

module Omnicron
    class HTTPClient
        @@content_type = "Content-Type"
        @@application_json = "application/json"
        @@request = {
            get: ->(url) { Net::HTTP::Get.new(url) },
            post: ->(url) { Net::HTTP::Post.new(url) }
        }

        def send_request(request)
            uri = request.uri
            Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
                ResponseWrapper.new(http.request(request))
            end
        end

        def json(url, method = :get, data = {})
            request = @@request[method.to_sym].call(url)
            request[@@content_type] = @@application_json
            request.body = JSON.generate(data)
            JsonResponse.new(send_request(request))
        end
    end
end