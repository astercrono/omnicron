module Omnicron
    class StoreWriter
        def write(data)
            raise NotImplementedError
        end

        def read
            raise NotImplementedError
        end
    end
end