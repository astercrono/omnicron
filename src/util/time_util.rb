module Omnicron
    module TimeUtil
        def self.current_ms
            (Time.now.to_f * 1000).to_i
        end
    end
end