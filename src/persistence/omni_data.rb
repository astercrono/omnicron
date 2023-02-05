require "singleton"
require "monitor"
require_relative "../util/time_util"
require_relative "./store_writer"
require_relative "../logging/logger"

module Omnicron
    class OmniData
        include Singleton
        include MonitorMixin

        def load(store)
            @store = store
            @model = nil
        end

        def data
            synchronize do
                @model = @store.read
                @model = new_model if @model.nil?
                yield @model
            end
        end

        def add_reddit_scrape(post_permalink)
            data do |model|
                model[:reddit][:scrape_history] << {
                    timestamp: TimeUtil.current_ms,
                    permalink: post_permalink
                }
                @store.write(model)
            end
        end

        def add_discord_url(url)
            data do |model|
                model[:discord][:bad_url_history] << {
                    timestamp: TimeUtil.current_ms,
                    url: url
                }
                @store.write(model)
            end
        end

        def reddit_scrape_link?(link)
            data do |model|
                model[:reddit][:scrape_history].any? do |record|
                    status = record[:permalink] == link
                    Log.instance.debug("Reddit Scrape Link Cache Status: (#{link}) - #{status}")
                    status
                end
            end
        end

        def discord_bad_url?(url)
            data do |model|
                model[:discord][:bad_url_history].any? do |record|
                    status = record[:url] == url
                    Log.instance.debug("Discord Bad URL Cache Status: (#{url}) - #{status}")
                    status
                end
            end
        end

        private

        def new_model
            {
                reddit: {
                    scrape_history: []
                },
                discord: {
                    bad_url_history: []
                }
            }
        end
    end
end