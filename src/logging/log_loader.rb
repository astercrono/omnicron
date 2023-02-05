require_relative "../config/config"
require_relative "./logger"

module Omnicron
    class LogLoader
        def self.load
            path = Config.instance.log["path"]
            rollover = Config.instance.log["rollover"]
            Log.instance.load(path: path, rollover: rollover)
        end
    end
end
