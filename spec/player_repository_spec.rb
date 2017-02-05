require "spec_helper"
require "yaml"

describe PlayerRepository do
    context "when the player has received a transfer" do
        it "should load a player from events" do
            stub_event_store = double
            event = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_name => "dummy name"
            }
            allow(stub_event_store).to receive(:load_events).and_return([event])
            player_repository = PlayerRepository.new(stub_event_store)
            player = player_repository.get_player("dummy name")
            expect(player.balance).to eq 5.55
        end
    end

    context "when there are multiple events" do
        it "should filter events by player name" do
            stub_event_store = double
            event1 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_name => "dummy player name"
            }
            event2 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_name => "dummy player name"                
            }
            event3 = {
                :type => "transfer_received", 
                :amount => 5.55, 
                :player_name => "other player name"                
            }

            allow(stub_event_store).to receive(:load_events).and_return([event1,event2,event3])
            player_repository = PlayerRepository.new(stub_event_store)
            player = player_repository.get_player("dummy player name")
            expect(player.balance).to eq 11.10
        end
    end
end