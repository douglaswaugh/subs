require "spec_helper"

describe Player do

  it "should create new player with name and zero balance" do
    player_name = "dummy player name"
    player = Player.new(player_name)
    expect(player.name).to eq player_name
    expect(player.balance).to eq 0
  end

  it "should update balance when transfer received event processed" do
    player = Player.new("dummy player name")
    player.handle_event({:amount => -5.45, :type => "transfer_received"})
    expect(player.balance).to eq -5.45
  end
end