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
    player.handle_event({:amount => 5.45, :type => "transfer_received"})
    expect(player.balance).to eq 5.45
  end

  it "should update balance when participated in practice event processed" do
    player = Player.new("dummy player name")
    player.handle_event({:type => "participated_in_practice", :amount => 3.45 })
    expect(player.balance).to eq 3.45
  end

  it "should update balance when provided balls event processed" do
    player = Player.new("dummy player name")
    player.handle_event({:type => "provided_balls", :amount => -3.50})
    expect(player.balance).to eq -3.5
  end

  it "should update balance when court booked event processed" do
    player = Player.new("dummy player name")
    player.handle_event({:type => "booked_court", :amount => -18})
    expect(player.balance).to eq -18
  end
end