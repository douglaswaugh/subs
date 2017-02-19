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
      event_date: "2017-02-13 00:00:00 +0000",
      practice_date: "2017-01-31 00:00:00 +0000",
      amount: "5.38"
    }

    event_builder = EventBuilder.new(uuid_service, time_service)

    event = event_builder.from_note("31/1/2017 c fee £5.38")
    expect(event.to_json).to eq expected_JSON.to_json
  end

  context("building a transfer recived event from note") do
    subject(:event) do
      uuid_service = double
      allow(uuid_service).to receive(:new_uuid).and_return("77b3efc6-031b-4b13-a182-83ac1c48beb6")

      time_service = double
      allow(time_service).to receive(:now).and_return(Time.new(2017,2,13))

      event_builder = EventBuilder.new(uuid_service, time_service)

      return event_builder.from_note("26/12/2016 paid £14.30")
    end

    it("should have event id") do
      expect(event[:event_id]).to eq "77b3efc6-031b-4b13-a182-83ac1c48beb6"
    end

    it("should have player id") do
      expect(event[:player_id]).to eq "5535f27b-6098-4ae8-9046-bf8971bdb627"
    end

    it("should have event_type_id") do
      expect(event[:event_type_id]).to eq "1c1bbb09-da4b-4e69-9835-a69342438ed7"
    end

    it("should have event date") do
      expect(event[:event_date].strftime("%D")).to eq Date.new(2017, 2, 13).strftime("%D")
    end

    it("should have pratcice date") do
      expect(event[:practice_date].strftime("%D")).to eq Date.new(2016,12,26).strftime("%D")
    end

    it("should have amount") do
      expect(event[:amount]).to eq "14.3"
    end

    it("should have transfer to") do
      expect(event[:transfer_to]).to eq "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"
    end
  end  
end