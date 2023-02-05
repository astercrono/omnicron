require "reddit_get"
require_relative "../autobot"
require_relative "../../config/features"

module Omnicron
    module Bot
        module Reddit
            class RedditBot < Autobot
                def initialize
                    super
                    @config = Config.instance
                end

                def run
                    if @config.feature?(Features::REDDIT_SUB_SCRAPE)
                        keyword_conf = @config.reddit["keyword_scan"]
                        subs = keyword_conf["scrape"]["subs"]

                        results = RedditGet::Subreddit.collect_all subs

                        subs.each do |sub|
                            results.send(sub.to_sym).each do |result|
                                emit_event(Events::REDDIT_POST, result)
                            end
                        end
                    end
                end
            end
        end
    end
end
