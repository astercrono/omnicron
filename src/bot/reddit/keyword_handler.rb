require_relative "../../event/event_handler"
require_relative "../../logging/logger"

module Omnicron
    module Bot
        module Reddit
            class KeywordHandler < HardEventHandler
                def initialize(keywords, event_emitter: nil)
                    @keywords = keywords
                    @event_emitter = event_emitter
                end

                def handle_event(post)
                    Log.instance.debug("Checking post for keywords: #{post.title[0..50]}")

                    match_title = @keywords.select { |word| post.title.downcase.include? word.downcase }
                    match_flair = @keywords.select { |word| post.link_flair_text.downcase.include? word.downcase }

                    matches = match_title || match_flair

                    if matches.empty?
                        Log.instance.debug("No Matches Found")
                    else
                        Log.instance.debug("Matches Found: #{matches}")
                        @event_emitter&.emit_event(Events::REDDIT_KEYWORD_MATCH, post)
                    end
                end
            end
        end
    end
end