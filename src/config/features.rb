module Omnicron
    module Features
        GOOGLE_API = "google-api"
        DISCORD = "discord"
        DISCORD_MESSAGE_READ = "discord-message-read"
        DISCORD_URL_PROTECTION = "discord-url-protection"
        REDDIT = "reddit"
        REDDIT_SUB_SCRAPE = "reddit-sub-scrape"
        REDDIT_KEYWORD_SCAN = "reddit-keyword-scan"
        REDDIT_KEYWORD_TO_DISCORD = "reddit-keyword-to-discord"
    end

    module FeatureGroups
        DISCORD_URL_PROTECTION = [Features::GOOGLE_API, Features::DISCORD_URL_PROTECTION, Features::DISCORD_MESSAGE_READ]
        DISCORD_KEYWORD_SEND = [Features::DISCORD, Features::REDDIT, Features::REDDIT_KEYWORD_SCAN, Features::REDDIT_KEYWORD_TO_DISCORD]
    end
end
