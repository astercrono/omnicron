require_relative "../event/event_emitter"
require_relative "../event/event_handler"

module Omnicron
    module Bot
        class Autobot < EventEmitter
            include EventHandler

            def run; end

            def handle_event(type, handler)
                receive_event(type) do |data|
                    handler.handle_event(data)
                end
            end
        end
    end
end