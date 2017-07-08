class Player
  def initialize(name)
    @name = name
    @balance = 0
  end

  def name
    @name
  end

  def balance
    @balance
  end

  def handle_event(event)
    if (event[:event_type_id] != '03ef1d0b-6a38-440f-9737-8fc5e0c19ab7')
      @balance = @balance + event[:amount]
    end
  end

  def self.get_player(name)
    return Player.new(name)
  end
end