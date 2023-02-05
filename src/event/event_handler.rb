module Omnicron
    module EventHandler
        def handle_event(type, handler)
            raise NotImplementedError
        end
    end

    class HardEventHandler
        include EventHandler
    end
end