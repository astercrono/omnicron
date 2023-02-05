require "optparse"

module Omnicron
    Arguments = Struct.new(:config)

    class ArgumentReader
        def initialize
            @banner = "Usage: run.rb [options]"
        end

        def read_arguments
            opt_list = []
            OptionParser.new do |opts|
                opts.banner = @banner

                opts.on("-c", "--config CONFIG", "Specify path to configuration") do |config|
                    opt_list << config
                end
            end.parse!

            Arguments.new(*opt_list)
        end
    end
end
