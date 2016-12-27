require "spec_helper"

describe Player do

  it "should create new player with name and zero balance" do
    player_name = "dummy player name"
    player = Player.new(player_name)
    expect(player.name).to eq player_name
    expect(player.balance).to eq 0
  end

  it "should get player by name" do
    player_name = "dummy player name"
    player = Player.get_player(player_name)
    expect(player.name).to eq player_name
  end
end