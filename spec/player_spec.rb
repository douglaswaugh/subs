require "spec_helper"

describe Player do

  it "should create new player with name and zero balance" do
    player_name = "dummy player name"
    player = Player.new(player_name)
    expect(player.name).to eq player_name
    expect(player.balance).to eq 0
  end

  it "should update balance when event processed" do
    player = Player.new("dummy player name")
    player.handle_event({:amount => 5.45})
    expect(player.balance).to eq 5.45
  end

  it 'should not update balance when carried event processed' do
    player = Player.new('dummy player name')
    player.handle_event({:amount => 5.45})
    player.handle_event({:amount => 5.45, :event_type_id => '03ef1d0b-6a38-440f-9737-8fc5e0c19ab7'})
    expect(player.balance).to eq 5.45
  end

  it 'should throw an exception when carried event processed amount does not equal the player balance' do
    player = Player.new('dummy player name')
    player.handle_event({:amount => 9.99})
    player.handle_event({:amount => 5.45, :event_type_id => '03ef1d0b-6a38-440f-9737-8fc5e0c19ab7'})
    expect {
      player.balance
    }.to raise_error(CarriedEventAmountDoesNotMatchBalanceError)
  end
end