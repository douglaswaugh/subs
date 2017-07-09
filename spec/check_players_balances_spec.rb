require 'spec_helper'

describe PlayerRepository, :validate_data => true do
  it 'should load all the players and their balances should be correct' do
    playerRepository = PlayerRepository.new(EventStore.new, PlayerIds.new(YamlLoader.new))

    playerRepository.get_players().each do |player|
      puts "Processing #{player}"
      playerRepository.get_player(player[0])
    end
  end
end