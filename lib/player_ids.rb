class PlayerIds
  def initialize(ymal_loader)
    @yaml_loader = ymal_loader
  end

  def get_player_id(name)
    player_ids = @yaml_loader.load('./data/players.yml')
    return player_ids[name.to_sym]
  end
end