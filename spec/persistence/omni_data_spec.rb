require "rspec"
require_relative "../../src/persistence/omni_data"
require_relative "../../src/persistence/omni_store"
require_relative "../../src/persistence/omni_store_factory"
require_relative "../../src/util/time_util"

RSpec.describe Omnicron::OmniData do
    context "Using MemoryOmniStore" do
        let(:omni_data) do
            store = Omnicron::OmniStoreFactory.instance.pick_store(type: Omnicron::StoreType::MEMORY)
            Omnicron::OmniData.instance.load(store)
            Omnicron::OmniData.instance
        end

        it "#load" do
            omni_data.data do |model|
                expect(model.keys).to include(:discord)
                expect(model.keys).to include(:reddit)
                expect(model[:reddit].keys).to eq([:scrape_history])
                expect(model[:discord].keys).to eq([:bad_url_history])
            end
        end

        it "#add_reddit_scrape" do
            expected_link = "This is a reddit add test"
            expected_ts = Omnicron::TimeUtil.current_ms

            omni_data.add_reddit_scrape(expected_link)

            scrape_exists = omni_data.data do |model|
                scrapes = model[:reddit][:scrape_history]
                scrapes.any? do |record|
                    record[:permalink] == expected_link && record[:timestamp] == expected_ts
                end
            end

            expect(scrape_exists).to eq(true)
        end

        it "#add_discord_url" do
            expected_link = "This is a discord add test"
            expected_ts = Omnicron::TimeUtil.current_ms

            omni_data.add_discord_url(expected_link)

            scrape_exists = omni_data.data do |model|
                scrapes = model[:discord][:bad_url_history]
                scrapes.any? do |record|
                    record[:url] == expected_link && record[:timestamp] == expected_ts
                end
            end

            expect(scrape_exists).to eq(true)
        end

        it "#reddit_scrape_link?" do
            expected_link = "This is a reddit check test"
            omni_data.add_reddit_scrape(expected_link)
            expect(omni_data.reddit_scrape_link?(expected_link)).to eq(true)
        end

        it "#discord_bad_url?" do
            expected_link = "This is a discord check test"
            omni_data.add_discord_url(expected_link)
            expect(omni_data.discord_bad_url?(expected_link)).to eq(true)
        end
    end
end