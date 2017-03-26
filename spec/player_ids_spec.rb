require 'spec_helper'

describe PlayerIds do
  it 'should load player ids from file' do
    yaml_loader = double
    player_ids = {
      "player_name" => "4f9a4832-0082-49d0-85a5-a1c4c66c85a4",
      "other_player_name" => "4700a9ee-8c0c-4874-8830-20b5a495d464"
    }
    allow(yaml_loader).to receive(:load).and_return(player_ids)

    player_ids = PlayerIds.new(yaml_loader)

    expect(player_ids.get_player_id('player_name')).to eq "4f9a4832-0082-49d0-85a5-a1c4c66c85a4"
  end
end
