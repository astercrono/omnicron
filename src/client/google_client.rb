require "net/http"
require_relative "./http_client"
require_relative "../model/google_browsing"

module Omnicron
    class GoogleSafeBrowsingClient < HTTPClient
        @@safe_browsing_url = "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=".freeze

        def initialize(key)
            @key = key
            @auth_uri = URI.parse("#{@@safe_browsing_url}#{@key}")
        end

        def check_status(urls)
            url_list = []
            urls.each { |u| url_list << { url: u } }

            data = {
                threatInfo: {
                    threatTypes: %w[MALWARE SOCIAL_ENGINEERING UNWANTED_SOFTWARE POTENTIALLY_HARMFUL_APPLICATION],
                    platformTypes: %w[WINDOWS LINUX OSX],
                    threatEntryTypes: %w[URL EXECUTABLE],
                    threatEntries: url_list
                }
            }

            GoogleUrlStatusResponse.new(json(@auth_uri, :post, data))
        end
    end
end