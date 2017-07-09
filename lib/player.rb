require_relative 'carried_event_amount_does_not_match_balance_error'

class Player
  def initialize(name)
    @name = name
    @events = []
  end

  def name
    @name
  end

  def balance
    balance = 0
    @events.each do |event|
      if event[:event_type_id] != '03ef1d0b-6a38-440f-9737-8fc5e0c19ab7'
        balance = balance + event[:amount]
      elsif event[:amount] != balance
        raise CarriedEventAmountDoesNotMatchBalanceError.new()
      end
    end

    return balance
  end

  def handle_event(event)
    @events.push(event)
  end

  def self.get_player(name)
    return Player.new(name)
  end
end