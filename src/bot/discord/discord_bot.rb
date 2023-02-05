require "discordrb"
require_relative "../autobot"
require_relative "../../event/event_handler"
require_relative "../../event/events"
require_relative "../../config/features"
require_relative "../../logging/logger"

module Omnicron
    module Bot
        module Discord
            class DiscordBot < Autobot
                def initialize
                    super
                    @config = Config.instance
                    @bot = nil
                end

                def run
                    @bot = Discordrb::Bot.new token: @config.discord["bot_key"]

                    if @config.feature?(Features::DISCORD_MESSAGE_READ)
                        @bot.message do |event|
                            emit_event(Events::DISCORD_MESSAGE, event)
                        end
                    end

                    @bot.run
                end

                def send_message(_server_id, channel_id, message)
                    @bot.send_message(channel_id, message)
                    Log.instance.info("Message Sent")
                end
            end
        end
    end
end