require "singleton"
require_relative "../bot/reddit/reddit_bot"
require_relative "../logging/logger"

module Omnicron
    class Config
        include Singleton

        def load(json)
            @json = json
        end

        def log
            puts @json
            @json["log"]
        end

        def storage
            @json["storage"]
        end

        def discord_invite_url
            dconf = discord

            url = dconf["invite_link"]
            app_id = dconf["app_id"]
            permissions = dconf["permissions_integer"]

            url = url.sub("${app_id}", app_id)
            url.sub("${permissions_integer}", permissions)
        end

        def google
            @json["google"]
        end

        def discord
            @json["discord"]
        end

        def reddit
            @json["reddit"]
        end

        def discord?
            !discord.empty?
        end

        def reddit?
            !reddit.empty?
        end

        def feature?(name)
            Log.instance.debug("Confirming Feature: #{name}")
            result = @json["features"].include? name
            Log.instance.debug("Feature Status: #{result}")
            result
        end

        def features?(names)
            names.select do |name|
                Log.instance.debug("Confirming Feature: #{name}")
                result = @json["features"].include? name
                Log.instance.debug("Feature Status: #{result}")
                result
            end.length == names.length
        end

        def feature_scope(features, &block)
            has_features = features?(features)
            block&.call() if has_features
        end
    end
end