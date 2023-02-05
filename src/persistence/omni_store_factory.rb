require "singleton"
require_relative "./omni_store"

module Omnicron
    class OmniStoreFactory
        include Singleton

        def pick_store(type: StoreType::MEMORY, log_verbose: false, path: nil)
            case type
            when StoreType::MEMORY
                pick_memory_store(log_verbose: log_verbose)
            when StoreType::PSTORE
                pick_pstore(path: path, log_verbose: log_verbose)
            else
                raise ArgumentError "Invalid Storage Type"
            end
        end

        private

        def pick_memory_store(log_verbose: false)
            MemoryOmniStore.new(log_verbose: log_verbose)
        end

        def pick_pstore(path: "", log_verbose: false)
            POmniStore.new(path, log_verbose: log_verbose)
        end
    end
end