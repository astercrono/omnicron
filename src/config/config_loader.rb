require_relative "./config"

module Omnicron
    class ConfigLoader
        def self.load(path)
            file = File.read(path)
            json = JSON.parse(file)
            Config.instance.load(json)
        rescue StandardError
            nil
        end
    end
end