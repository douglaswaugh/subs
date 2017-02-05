require 'yaml'

class PlayerRepository
    def initialize(event_store = EventStore.new)
        @event_store = event_store
    end

    def get_player(name)
        events = @event_store.load_events

        player_events = filter_events_by_player(events, name)

        player = Player.new(name)

        player_events.each do |event| 
            player.handle_event(event)
        end

        return player
    end

    def filter_events_by_player(events, name)
        events.select { |item| item[:player_name] == name }
    end
end