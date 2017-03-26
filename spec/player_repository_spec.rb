require "spec_helper"
require "yaml"

describe PlayerRepository do
    context "when the player has received a transfer" do
        it "should load a player from events" do
            stub_player_ids = double
            allow(stub_player_ids).to receive(:get_player_id).and_return("514d2f54-ec98-445f-ad19-4b9e616f905d")

            stub_event_store = double
            event = {
                :type => "transfer_received", 
                :amount => 5.55,
                :player_id => "514d2f54-ec98-445f-ad19-4b9e616f905d"
            }
            allow(stub_event_store).to receive(:load_events).and_return([event])
            player_repository = PlayerRepository.new(stub_event_store, stub_player_ids)
            player = player_repository.get_player("dummy name")
            expect(player.balance).to eq 5.55
        end
    end

    context "when there are multiple events" do
        it "should filter events by player name" do
=begin
{
    "event_id":"e95b4b62-5072-4aca-8a6f-78303d97d10e",
    "player_id":"514d2f54-ec98-445f-ad19-4b9e616f905d",
    "event_type_id":"29a2508d-5581-48a0-a286-27b0efafdb7b",
    "event_date":"2017-03-26 12:47:14 +0100",
    "amount":"5.38",
    "practice_date":"2015-12-10 00:00:00 +0000"
}
=end
            stub_player_ids = double
            allow(stub_player_ids).to receive(:get_player_id).and_return("514d2f54-ec98-445f-ad19-4b9e616f905d")

            stub_event_store = double
            event1 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_id => "514d2f54-ec98-445f-ad19-4b9e616f905d"
            }
            event2 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_id => "514d2f54-ec98-445f-ad19-4b9e616f905d"                
            }
            event3 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_id => "29a2508d-5581-48a0-a286-27b0efafdb7b"
            }
            allow(stub_event_store).to receive(:load_events).and_return([event1,event2,event3])

            player_repository = PlayerRepository.new(stub_event_store, stub_player_ids)
            player = player_repository.get_player("dummy player name")
            expect(player.balance).to eq 11.10
        end
    end
end