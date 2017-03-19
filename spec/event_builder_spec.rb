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

  let(:team_member_service) do
    team_member_service = double
    allow(team_member_service).to receive(:get_team_member_id_by_name).and_return('dfff4c34-6300-49c7-b9f0-a1c00a460fa8')
    return team_member_service
  end

  context("building a participated event from note") do
    subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, "26/12/2016 c fee £14.30")
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

    it('should have practice date') do
      assert_event_has_practice_date(event)
    end
  end

  context("transfer sent events") do
    context("negative transfers sent") do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 paid -£14.30")
      end

      it("should have a negative amount", focus: true) do
        expect(event[:amount]).to eq "-14.3"
      end
    end

    context("positive transfers sent") do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 paid £14.30")
      end

      it "should have a negative amount", :focus => true do
        expect(event[:amount]).to eq "-14.3"
      end
    end
  end

  context("building a transfer sent via system event from note") do
    subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, "26/12/2016 paid -£14.30")
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

    it("should have transferred via") do 
      expect(event[:transferred_via]).to eq "system"
    end
  end

  context("building a transfer received via system event from note") do
    subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, "26/12/2016 trans £23.35")
    end

    it('should have standard properties') do
      has_common_fields(event)
    end

    it('should have transfer sent event type id') do
      expect(event[:event_type_id]).to eq "6dc04656-184a-4ae1-99b9-e726d6988ba9"
    end

    it('should have transfer from') do
      expect(event[:transfer_sent_from]).to eq "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"
    end

    it('should have amount') do
      expect(event[:amount]).to eq '23.35'
    end

    it('should have transferred via') do
      expect(event[:transferred_via]).to eq 'system'
    end

    context('from note with trnsfr event string') do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 trnsfr £23.35")
      end

      it('should have transfer sent event type id') do
        expect(event[:event_type_id]).to eq '6dc04656-184a-4ae1-99b9-e726d6988ba9'
      end
    end

    context('from note with transfer event string') do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 transfer £23.35")
      end

      it('should have transfer sent event type id') do
        expect(event[:event_type_id]).to eq '6dc04656-184a-4ae1-99b9-e726d6988ba9'
      end
    end

    context('from note with transfer event string and named sender') do
      let(:team_member_service) do
        team_member_service = double
        allow(team_member_service).to receive(:get_team_member_id_by_name).and_return('dfff4c34-6300-49c7-b9f0-a1c00a460fa8')
        return team_member_service
      end

      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 transfer from michael £23.35")
      end

      it('should have transfer from player id') do
        expect(event[:transfer_sent_from]).to eq 'dfff4c34-6300-49c7-b9f0-a1c00a460fa8'
      end
    end
  end

  context("building a transfer sent via paypal event from note") do
    subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 paypal -£14.30")
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

    it("should have transferred via") do
      expect(event[:transferred_via]).to eq "paypal"
    end
  end

  context("building a transfer sent via cash event from note") do
    subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 cash -£14.30")
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

    it("should have transferred via") do
      expect(event[:transferred_via]).to eq "cash"
    end
  end

  context("building a balls provided event from note") do
    subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 balls -£3.50")
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

    it('should have practice date') do
      assert_event_has_practice_date(event)
    end
  end

  context("building a booked court event from note") do
    subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 booking -£18")
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

  context("building a pies event from note") do
    subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 pies £18")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have amount") do
      expect(event[:amount]).to eq "18.0"
    end

    context('with event string m pies') do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, "26/12/2016 m pies £18")
      end

      it('should have pies event type id') do
        expect(event[:event_type_id]).to eq '3f211c34-6257-47fa-85c4-38d68530eba9'
      end
    end

    it('should have practice date') do
      assert_event_has_practice_date(event)
    end
  end

  context("building a wine event from note") do
    subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, "26/12/2016 wine £18")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have amount") do
      expect(event[:amount]).to eq "18.0"
    end

    it('should have practice date') do
      assert_event_has_practice_date(event)
    end
  end

  context("building a share of cancellation event from note") do
    subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, "26/12/2016 cancelled £0.38")
    end

    it("should have standard properties") do
      has_common_fields(event)
    end

    it("should have amount") do
      expect(event[:amount]).to eq "0.38"
    end

    it('should have practice date') do
      assert_event_has_practice_date(event)
    end
  end

  context('building a match event from note') do
    context('with m fee event string') do
      subject(:event) do
      event_builder = get_event_builder()
      return get_event_from_builder(event_builder, '26/12/2016 m fee £7.50')
      end

      it('should have standard properties') do
        has_common_fields(event)
      end

      it("should have amount") do
        expect(event[:amount]).to eq "7.5"
      end

      it('should have the match fee event type id') do
        expect(event[:event_type_id]).to eq 'edbccc86-d6ad-4057-a3c5-8d7a54f9c507'
      end

      # should have the match date
    end

    context('with match event string') do
      subject(:event) do
        event_builder = get_event_builder()
        return get_event_from_builder(event_builder, '26/12/2016 match £7.50')
      end

      it('should have the match fee event type id') do
        expect(event[:event_type_id]).to eq 'edbccc86-d6ad-4057-a3c5-8d7a54f9c507'
      end

      # should have the match date
    end
  end

  context("unknown event type") do
    it("should throw exception") do
      event_builder = EventBuilder.new(uuid_service, time_service, team_member_service)
      expect{event_builder.from_note("26/12/2016 unknown event £3.50", 'player_name')}.to raise_error(EventTypeUnknownError)
    end
  end

  context("note format") do
    it("should return true for a note with valid format") do
      note = "14/01/2017 c fee £3.50"
      expect(EventBuilder.valid_note?(note)).to eq true
    end

    it("should return false for a note with invalid format") do
      note = "this is an invalid note"
      expect(EventBuilder.valid_note?(note)).to eq false
    end
  end

  context("carried notes") do
    it("should return true for a note of type carried") do
      note = "13/01/2017 carried £34.00"
      expect(EventBuilder.carried_event?(note)).to eq true
    end

    it("should return false for a note not of type carried") do
      note = "13/01/2017 some other event £30.00"
      expect(EventBuilder.carried_event?(note)).to eq false
    end

    it("should be insensitive to case") do
      note = "13/01/2017 cArRiEd £23.53"
      expect(EventBuilder.carried_event?(note)).to eq true
    end
  end

  def assert_event_has_practice_date(event)
    expect(event[:practice_date].strftime("%D")).to eq Date.new(2016,12,26).strftime("%D")
  end

  def get_event_builder
    return EventBuilder.new(uuid_service, time_service, team_member_service)
  end

  def get_event_from_builder(event_builder, note)
    event_builder.from_note(note, 'player name')
  end

  def has_common_fields(event)
    expect(event[:event_id]).to eq "77b3efc6-031b-4b13-a182-83ac1c48beb6"
    expect(event[:player_id]).to eq 'dfff4c34-6300-49c7-b9f0-a1c00a460fa8'
    expect(event[:event_date].strftime("%D")).to eq Date.new(2017, 2, 13).strftime("%D")
  end
end