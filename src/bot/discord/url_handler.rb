require_relative "../../event/event_handler"
require_relative "../../logging/logger"

module Omnicron
    module Bot
        module Discord
            class UrlHandler < HardEventHandler
                def handle_event(event)
                    urls = URI.extract(event.message.content)

                    unless urls.empty?
                        Log.instance.info("Found URL Count: #{urls.nil? ? 0 : urls.count}")
                        urls.each { |u| Log.instance.info("Found URL: #{u}") }
                        handle_urls(event, urls)
                    end
                end
            end
        end
    end
end