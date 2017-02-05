require 'yaml'

class PlayerRepository
    def get_player(name)
        event = YAML.load_file("data/1.yml")
        player = Player.new(event[:player_name])
        player.handle_transfer_event(event)
        return player
    end
end