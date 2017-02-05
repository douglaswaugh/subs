require "spec_helper"
require "yaml"

describe PlayerRepository do
    context "when the player has received a transfer" do
        before(:each) do
            File.open("data/1.yml", "w") do |file|
                event1 = {
                    :id => 1,
                    :player_name => "dummy name",
                    :type => "transfer",
                    :from => "dummy transferer",
                    :to => "dummy receiver",
                    :transfer_type => "coolhurst account",
                    :amount => 5.55
                }
                file.write(event1.to_yaml)
            end
        end

        after(:each) do
            files = File.delete("data/1.yml") if File.exist?("data/1.yml")
        end

        it "should load a player from events" do
            playerRepository = PlayerRepository.new
            player = playerRepository.get_player("dummy name")
            expect(player.balance).to eq 5.55
        end
    end
end