require "bigdecimal"
require "time"

class EventBuilder
  def initialize(uuid_service, time_service)
    @uuid_service = uuid_service
    @time_service = time_service
    @events = {
      c_fee: "29a2508d-5581-48a0-a286-27b0efafdb7b",
      transfer_to: "1c1bbb09-da4b-4e69-9835-a69342438ed7"
    }
  end

  def from_note(note)
    practice_date, event_string, amount = note.match(/([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})\s+((?<= )[a-z ]*(?= ))\s+-?£(\d+.?\d{0,2})/i).captures

    decimal_amount = BigDecimal.new(amount)

    if (event_string == "c fee")
      event_type = :c_fee
    elsif (event_string == "paid" && decimal_amount >= 0)
      event_type = :transfer_to
    end

    expected_JSON = {
      event_id: "77b3efc6-031b-4b13-a182-83ac1c48beb6",
      player_id: "5535f27b-6098-4ae8-9046-bf8971bdb627",
      event_type_id: @events[event_type],
      event_date: @time_service.now,
      practice_date: Time.parse(practice_date),
      amount: decimal_amount.to_s("F")
    }

    if (event_type == :transfer_to)
      expected_JSON[:transfer_to] = "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"
    end

    return expected_JSON
  end
end