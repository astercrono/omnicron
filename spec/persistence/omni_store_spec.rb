require "rspec"
require_relative "../../src/persistence/omni_store"
require_relative "../../src/persistence/omni_store_factory"

RSpec.describe Omnicron::OmniStore do
    context "Using MemoryOmniStore" do
        let(:data) { { foo: 1 } }

        it "#read/write works" do
            store = Omnicron::OmniStoreFactory.instance.pick_store(type: Omnicron::StoreType::MEMORY)
            store.write(data)

            stored_data = store.read
            expect(stored_data).to eq(data)
        end
    end
end