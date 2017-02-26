require "spec_helper"
require "json"

describe EventBuilder do
  let(:uuid_service) do
    uuid_service = double
    allow(uuid_service).to receive(:new_uuid).and_return("77b3efc6-031b-4b13-a182-83ac1c48beb6")
    return uuid_service
  end

  let(:time_service) do
    time_service = double
    allow(time_service).to receive(:now).and_return(Time.new(2017,2,13))
    return time_service
  end

  context("building a participated event from note") do
    subject(:event) do
      event_builder = EventBuilder.new(uuid_service, time_service)
      event = event_builder.from_note("26/12/2016 c fee £14.30")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have participated in practice event type id") do
      expect(event[:event_type_id]).to eq "29a2508d-5581-48a0-a286-27b0efafdb7b"
    end

    it("should have amount") do
      expect(event[:amount]).to eq "14.3"
    end
  end

  context("building a transfer sent event from note") do
    subject(:event) do
      event_builder = EventBuilder.new(uuid_service, time_service)
      return event_builder.from_note("26/12/2016 paid -£14.30")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have transfer sent event type id") do
      expect(event[:event_type_id]).to eq "1c1bbb09-da4b-4e69-9835-a69342438ed7"
    end

    it("should have transfer to") do
      expect(event[:transfer_sent_to]).to eq "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"
    end

    it("should have amount") do
      expect(event[:amount]).to eq "-14.3"
    end
  end

  context("building a balls provided event from note") do
    subject(:event) do
      event_builder = EventBuilder.new(uuid_service, time_service)
      return event_builder.from_note("26/12/2016 balls -£3.50")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have balls provided event type id") do
      expect(event[:event_type_id]).to eq "c219a3fe-bdee-4e21-ae0c-0504916650fd"
    end

    it("should have amount") do
      expect(event[:amount]).to eq "-3.5"
    end
  end

  context("building a booked court event from note") do
    subject(:event) do
      event_builder = EventBuilder.new(uuid_service, time_service)
      return event_builder.from_note("26/12/2016 booking -£18")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have booked court event type id") do
      expect(event[:event_type_id]).to eq "bcab570e-add5-4082-8928-474508113771"
    end

    it("should have amount") do
      expect(event[:amount]).to eq "-18.0"
    end

    it("should have court booking date") do
      expect(event[:court_booked_date].strftime("%D")).to eq Date.new(2016,12,26).strftime("%D")
    end
  end

  context("unknown event type") do
    it("should throw exception") do
      event_builder = EventBuilder.new(uuid_service, time_service)
      expect{event_builder.from_note("26/12/2016 unknown event £3.50")}.to raise_error(EventTypeUnknownError)
    end
  end

  def has_common_fields(event)
    expect(event[:event_id]).to eq "77b3efc6-031b-4b13-a182-83ac1c48beb6"
    expect(event[:player_id]).to eq "5535f27b-6098-4ae8-9046-bf8971bdb627"
    expect(event[:event_date].strftime("%D")).to eq Date.new(2017, 2, 13).strftime("%D")
    expect(event[:practice_date].strftime("%D")).to eq Date.new(2016,12,26).strftime("%D")
  end
end