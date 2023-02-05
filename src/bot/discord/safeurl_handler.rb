require_relative "./url_handler"
require_relative "../../logging/logger"
require_relative "../../config/config"
require_relative "../../persistence/omni_data"

module Omnicron
    module Bot
        module Discord
            class SafeUrlHandler < UrlHandler
                def initialize(safeurl_service, image: nil)
                    @service = safeurl_service
                    @image = image
                end

                def handle_urls(event, urls)
                    urls.filter! do |u|
                        status = OmniData.instance.discord_bad_url?(u)
                        reject event if status
                        !status
                    end

                    unless urls.empty?
                        response = @service.check_status(urls)
                        response.match? ? bad_url(event, urls) : good_url(event, urls)
                    end
                end

                def bad_url(event, urls)
                    reject event
                    urls.each do |u|
                        Log.instance.debug("Bad Url: #{u}")
                        OmniData.instance.add_discord_url(u)
                    end
                end

                def good_url(_event, urls)
                    urls.each { |u| Log.instance.debug("Good Url: #{u}") }
                end

                def reject(event)
                    response = "**Notice**: Recent message by <@#{event.user.id}> contained a potentially unsafe URL.\n*Message yeeted and deleted.*"

                    event.message.delete

                    if @image.nil?
                        event.response response
                    else
                        event.respond "#{response}\n#{@image}"
                    end
                end
            end
        end
    end
end