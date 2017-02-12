require "spec_helper"
require "json"

describe EventBuilder do
  it("should build participated in practice event from note") do
    uuid_service = double
    allow(uuid_service).to receive(:new_uuid).and_return("77b3efc6-031b-4b13-a182-83ac1c48beb6")

    time_service = double
    allow(time_service).to receive(:now).and_return(Time.new(2017,2,13))

    expected_JSON = {
      event_id: "77b3efc6-031b-4b13-a182-83ac1c48beb6",
      player_id: "5535f27b-6098-4ae8-9046-bf8971bdb627",
      event_type_id: "29a2508d-5581-48a0-a286-27b0efafdb7b",
      event_date: "13/2/2017",
      practice_date: "31/1/2017",
      amount: "5.38"
    }

    event_builder = EventBuilder.new(uuid_service, time_service)

    event = event_builder.from_note("31/1/2017 c fee £5.38")
    expect(event.to_json).to eq expected_JSON.to_json
  end
end