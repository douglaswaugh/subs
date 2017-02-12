require "bigdecimal"

class EventBuilder
  def initialize(uuid_service, time_service)
    @uuid_service = uuid_service
    @time_service = time_service
    @events = {
      "c fee".to_sym => "29a2508d-5581-48a0-a286-27b0efafdb7b"
    }
  end

  def from_note(note)
    practice_date, event_type, amount = note.match(/([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})\s+((?<= )[a-z ]*(?= ))\s+-?£(\d+.?\d{0,2})/i).captures

    decimal_amount = BigDecimal.new(amount)

    expected_JSON = {
      event_id: "77b3efc6-031b-4b13-a182-83ac1c48beb6",
      player_id: "5535f27b-6098-4ae8-9046-bf8971bdb627",
      event_type_id: @events[event_type.to_sym],
      event_date: "13/2/2017",
      practice_date: practice_date,
      amount: decimal_amount.to_s("F")
    }

    return expected_JSON
  end
end