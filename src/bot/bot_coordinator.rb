require "concurrent-ruby"
require_relative "../config/features"
require_relative "../logging/logger"
require_relative "../event/events"
require_relative "../event/event_handler"
require_relative "./discord/safeurl_handler"
require_relative "./discord/discord_bot"
require_relative "./reddit/keyword_handler"
require_relative "./reddit_discord_send_handler"
require_relative "./reddit/reddit_bot"
require_relative "../client/google_client"
require_relative "../service/safeurl/google_safeurl_service"

module Omnicron
    module Bot
        class BotCoordinator
            # TODO: Pass bots in as parameters - better for unit testing
            def initialize
                @config = Config.instance
                @bots = {}
            end

            def run
                Log.instance.info("Starting bots")
                feature_scope [Features::DISCORD] do
                    @bots[:discord] = dbot = run_discord
                    discord_event_handling(dbot)
                end

                feature_scope [Features::REDDIT] do
                    @bots[:reddit] = rbot = run_reddit
                    reddit_event_handling(rbot)
                end
            end

            private

            def feature_scope(features, &block)
                @config.feature_scope(features, &block)
            end

            def run_discord
                Log.instance.info("Creating Discord Bot")
                bot = Bot::Discord::DiscordBot.new
                Concurrent::Promises.future(bot) do |dbot|
                    Log.instance.info("Invite Link: #{@config.discord_invite_url}")
                    dbot&.run
                end
                bot
            end

            def run_reddit
                Log.instance.info("Creating Reddit Bot")
                bot = Bot::Reddit::RedditBot.new
                Concurrent::TimerTask.new(execution_interval: @config.reddit["check_interval"]) do
                    bot&.run
                end.execute
                bot
            end

            def discord_event_handling(bot)
                feature_scope FeatureGroups::DISCORD_URL_PROTECTION do
                    safe_browsing_client = GoogleSafeBrowsingClient.new(@config.google["api_key"])
                    safe_browser_service = GoogleSafeUrlService.new(safe_browsing_client)

                    safeurl_handler = Discord::SafeUrlHandler.new(safe_browser_service, image: @config.discord["bad_url_image"])

                    bot.handle_event(Events::DISCORD_MESSAGE, safeurl_handler)
                end
            end

            def reddit_event_handling(bot)
                feature_scope [Features::REDDIT_KEYWORD_SCAN] do
                    keyword_conf = @config.reddit["keyword_scan"]
                    keywords = keyword_conf["scrape"]["keywords"]

                    keyword_handler = Reddit::KeywordHandler.new(keywords, event_emitter: bot)
                    bot.handle_event(Events::REDDIT_POST, keyword_handler)

                    feature_scope [Features::REDDIT_KEYWORD_TO_DISCORD] do
                        send_handler = RedditDiscordSendHandler.new(@bots[:discord], bot)
                        bot.handle_event(Events::REDDIT_KEYWORD_MATCH, send_handler)
                    end
                end
            end
        end
    end
end