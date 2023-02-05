require "pstore"
require_relative "../config/config"
require_relative "../logging/logger"
require_relative "./store_writer"

module Omnicron
    module StoreType
        MEMORY = "memory"
        PSTORE = "pstore"
    end

    class OmniStore < StoreWriter
        def log_verbose?
            false
        end
    end

    class MemoryOmniStore < OmniStore
        def initialize(log_verbose: false)
            @store = nil
            @root = :data
            @log_verbose = log_verbose
            @store = {}
        end

        def write(data)
            @store[@root] = data
        end

        def read
            data = @store.fetch(@root, nil)
            Log.instance.debug(data) if log_verbose?
            data
        end

        def log_verbose?
            @log_verbose
        end
    end

    class POmniStore < OmniStore
        def initialize(path, log_verbose: false)
            @store = nil
            @root = :data
            @path = path
            @log_verbose = log_verbose
            @store = PStore.new(path)
        end

        def write(data)
            @store.transaction do
                @store[@root] = data
            end
        end

        def read
            @store.transaction(true) do
                data = @store.fetch(@root, nil)
                Log.instance.debug(data) if log_verbose?
                data
            end
        end

        def log_verbose?
            @log_verbose
        end
    end
end