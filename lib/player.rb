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

  def handle_transfer_event(event)
    @balance = @balance + event[:amount]
  end

  def self.get_player(name)
    return Player.new(name)
  end
end