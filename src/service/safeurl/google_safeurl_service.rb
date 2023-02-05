require_relative "./safeurl_service"

module Omnicron
    class GoogleSafeUrlService < SafeUrlService
        def initialize(client)
            @client = client
        end

        def check_status(urls)
            @client.check_status(urls)
        end
    end
end