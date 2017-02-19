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
    send(event[:type], event)
  end

  def transfer_received(event)
    @balance = @balance + event[:amount]
  end

  def transfer_sent(event)
    @balance = @balance + event[:amount]
  end

  def participated_in_practice(event)
    @balance = @balance + event[:amount]
  end

  def provided_balls(event)
    @balance = @balance + event[:amount]
  end

  def booked_court(event)
    @balance = @balance + event[:amount]
  end

  def paid(event)
    @balance = @balance + event[:amount]
  end

  def self.get_player(name)
    return Player.new(name)
  end
end