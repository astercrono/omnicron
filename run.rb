#!/usr/bin/env ruby

require "json"
require "uri"
require "concurrent-ruby"
require_relative "./src/environment/argument_reader"
require_relative "./src/config/config_loader"
require_relative "./src/bot/bot_coordinator"
require_relative "./src/logging/logger"
require_relative "./src/logging/log_loader"
require_relative "./src/persistence/omni_data"
require_relative "./src/persistence/omni_store_factory"

module Omnicron
    class Runner
        def run
            arguments = ArgumentReader.new.read_arguments
            ConfigLoader.load(arguments&.config)
            LogLoader.load

            store = OmniStoreFactory.instance.pick_store(
                type: Config.instance.storage["type"],
                path: Config.instance.storage["path"],
                log_verbose: Config.instance.log["verbose"]
            )

            OmniData.instance.load(store)

            Bot::BotCoordinator.new.run

            Log.instance.info("Omnicron Up")
            loop do
                sleep 60
                Log.instance.debug("Keepalive")
            end
            Log.instance.info("Omnicron Down")
        end
    end
end

Omnicron::Runner.new.run