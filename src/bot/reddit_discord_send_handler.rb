require_relative "../event/event_handler"
require_relative "../logging/logger"
require_relative "../persistence/omni_store"

module Omnicron
    module Bot
        class RedditDiscordSendHandler < Omnicron::HardEventHandler
            def initialize(discord_bot, reddit_bot)
                @config = Config.instance
                @discord_bot = discord_bot
                @reddit_bot = reddit_bot
            end

            def handle_event(post)
                if @config.features?(FeatureGroups::DISCORD_KEYWORD_SEND)
                    send_config = @config.reddit["keyword_scan"]["send_to_discord"]
                    server_id = send_config["server_id"]
                    channel_id = send_config["channel_id"]
                    link = "https://reddit.com#{post.permalink}"

                    if OmniData.instance.reddit_scrape_link?(link)
                        Log.instance.debug("Link already sent: #{link}")
                    else
                        Log.instance.info("Sending To Discord: #{server_id}:#{channel_id} - #{post.title[0, 50]}")
                        @discord_bot.send_message(server_id, channel_id, link)

                        OmniData.instance.add_reddit_scrape(link)
                    end
                end
            end
        end
    end
end