require 'yaml'
require_relative 'player'

class PlayerRepository
    def initialize(event_store = EventStore.new, player_ids)
        @event_store = event_store
        @player_ids = player_ids
    end

    def get_player(name)
        events = @event_store.load_events
        player_id = @player_ids.get_player_id(name)
        player_events = filter_events_by_player(events, player_id)

        player = Player.new(name)

        player_events.each do |event|
            player.handle_event(event)
        end

        return player
    end

    def get_players()
        return @player_ids.get_players()

    end

    def filter_events_by_player(events, player_id)
        events.select { |item| item[:player_id] == player_id }
    end
end