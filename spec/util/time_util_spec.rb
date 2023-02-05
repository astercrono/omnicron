require "rspec"
require_relative "../../src/util/time_util"

RSpec.describe Omnicron::TimeUtil do
    describe "#current_ms" do
        it "Current MS is Correct" do
            expected_ms = (Time.now.to_f * 1000).to_i
            actual_ms = Omnicron::TimeUtil.current_ms
            expect(actual_ms).to eq(expected_ms)
        end
    end
end
