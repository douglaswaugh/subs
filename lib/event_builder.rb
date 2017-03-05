require "bigdecimal"
require "time"
require_relative "event_type_unknown_error"

class EventBuilder
  @@note_pattern = /([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})\s+((?<= )[a-z ]*(?= ))\s+(-?)£(\d+.?\d{0,2})/i
  def initialize(uuid_service, time_service)
    @uuid_service = uuid_service
    @time_service = time_service
    @events = {
      c_fee: "29a2508d-5581-48a0-a286-27b0efafdb7b",
      transfer_sent: "1c1bbb09-da4b-4e69-9835-a69342438ed7",
      balls_provided: "c219a3fe-bdee-4e21-ae0c-0504916650fd",
      court_booked: "bcab570e-add5-4082-8928-474508113771"
    }
    @other_pattern = /.*/
  end

  def get_event_type_from_event_string(event_string, decimal_amount)
    event_type = "unknown".to_sym

    if (event_string == "c fee")
      event_type = :c_fee
    elsif (event_string == "paid" || event_string == "paypal" || event_string == "cash")
      event_type = :transfer_sent
    elsif (event_string == "balls")
      event_type = :balls_provided
    elsif (event_string == "booking")
      event_type = :court_booked
    elsif (event_string == "pies")
      event_type = :pies
    elsif (event_string == "wine")
      event_type = :wine
    elsif (event_string == "cancelled")
      event_type = :cancelled
    else
      raise EventTypeUnknownError.new(), "#{event_string} unknown"
    end

    return event_type
  end

  def from_note(note)
    practice_date, event_string, amount_sign, amount = note.match(@@note_pattern).captures

    event_string = event_string.downcase

    decimal_amount = BigDecimal.new(amount_sign + amount)

    event_type = get_event_type_from_event_string(event_string, decimal_amount)

    event = {
      event_id: "77b3efc6-031b-4b13-a182-83ac1c48beb6",
      player_id: "5535f27b-6098-4ae8-9046-bf8971bdb627",
      event_type_id: @events[event_type],
      event_date: @time_service.now,
      practice_date: Time.parse(practice_date),
      amount: decimal_amount.to_s("F")
    }

    if (event_type == :transfer_sent)
      event[:transfer_sent_to] = "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"

      if (event_string == "paid")
        event[:transferred_via] = "system"
      else
        event[:transferred_via] = event_string
      end

      event[:amount] = (0 - decimal_amount.abs).to_s("F")
    end

    if (event_type == :court_booked)
      event[:court_booked_date] = Time.parse(practice_date)
    end

    return event
  end

  def self.valid_note?(note)
    if note =~ @@note_pattern
      return true
    end

    return false
  end

  def self.carried_event?(note)
    practice_date, event_string, amount_sign, amount = note.match(@@note_pattern).captures
    return (event_string == "carried")
  end
end