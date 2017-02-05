require "spec_helper"

describe EventStore do
    before(:each) do
        File.open("data/file1.yml", "w") do |file| 
            file.write("file1.yml")
        end
        File.open("data/file2.yml", "w") do |file|
            file.write("file2.yml")
        end
    end

    after(:each) do
        File.delete("data/file1.yml")
        File.delete("data/file2.yml")
    end

    it "should load the events from the event store" do
        event_store = EventStore.new
        events = event_store.load_events
        expect(events.count).to eq 2
    end
end