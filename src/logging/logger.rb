require "logger"
require "singleton"

module Omnicron
    class Log
        include Singleton

        def load(path: nil, rollover: "daily")
            @path = path
            @rollover = rollover
            @loggers = [Logger.new(STDOUT)]
            @loggers << Logger.new(@path, @rollover) unless @path.nil?
        end

        def log(level, message)
            @loggers&.each do |l|
                l.send(level.to_sym, message)
            end
        end

        def unknown(message)
            log :unknown, message
        end

        def fatal(message)
            log :fatal, message
        end

        def error(message)
            log :error, message
        end

        def warn(message)
            log :warn, message
        end

        def info(message)
            log :info, message
        end

        def debug(message)
            log :debug, message
        end
    end
end