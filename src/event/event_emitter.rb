module Omnicron
    EventReceiver = Struct.new(:type, :handler)

    class EventEmitter
        def initialize
            @receivers = []
        end

        def receive_event(type, &handler)
            @receivers << EventReceiver.new(type, handler)
        end

        def emit_event(type, data)
            @receivers&.each do |receiver|
                receiver.handler.call(data) if receiver.type == type
            end
        end

        def clear_receivers
            @receivers.clear
        end
    end
end