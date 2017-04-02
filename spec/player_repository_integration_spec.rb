require 'spec_helper'

describe PlayerRepository, :single => true do
  it 'should load player from disk' do
    player_repository = PlayerRepository.new(EventStore.new, PlayerIds.new(YamlLoader.new))
    player = player_repository.get_player('Udi')

    expect(player.name).to eq 'Udi'
    expect(player.balance).to eq 3.88
  end
end