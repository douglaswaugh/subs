require "bigdecimal"
require "time"

class EventBuilder
  def initialize(uuid_service, time_service)
    @uuid_service = uuid_service
    @time_service = time_service
    @events = {
      c_fee: "29a2508d-5581-48a0-a286-27b0efafdb7b",
      transfer_sent: "1c1bbb09-da4b-4e69-9835-a69342438ed7",
      balls_provided: "c219a3fe-bdee-4e21-ae0c-0504916650fd",
      court_booked: "bcab570e-add5-4082-8928-474508113771"
    }
  end

  def get_event_type_from_event_string(event_string, decimal_amount)
    event_type = "unknown".to_sym 

    if (event_string == "c fee")
      event_type = :c_fee
    elsif (event_string == "paid" && decimal_amount <= 0)
      event_type = :transfer_sent
    elsif (event_string == "balls")
      event_type = :balls_provided
    elsif (event_string == "booking")
      event_type = :court_booked
    end

    return event_type
  end

  def from_note(note)
    practice_date, event_string, amount_sign, amount = note.match(/([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})\s+((?<= )[a-z ]*(?= ))\s+(-?)£(\d+.?\d{0,2})/i).captures

    decimal_amount = BigDecimal.new(amount_sign + amount)

    event_type = get_event_type_from_event_string(event_string, decimal_amount)

    expected_JSON = {
      event_id: "77b3efc6-031b-4b13-a182-83ac1c48beb6",
      player_id: "5535f27b-6098-4ae8-9046-bf8971bdb627",
      event_type_id: @events[event_type],
      event_date: @time_service.now,
      practice_date: Time.parse(practice_date),
      amount: decimal_amount.to_s("F")
    }

    if (event_type == :transfer_sent)
      expected_JSON[:transfer_sent_to] = "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"
    end

    if (event_type == :court_booked)
      expected_JSON[:court_booked_date] = Time.parse(practice_date)
    end

    return expected_JSON
  end
end