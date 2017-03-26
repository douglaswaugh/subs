require "bigdecimal"
require "time"
require_relative "event_type_unknown_error"

class EventBuilder
  @@note_pattern = /([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})\s+((?<= )[a-z ]*(?= ))\s+(-?)£(\d+.?\d{0,2})/i
  def initialize(uuid_service, time_service, team_member_service)
    @uuid_service = uuid_service
    @time_service = time_service
    @team_member_service = team_member_service
    @events = {
      c_fee: "29a2508d-5581-48a0-a286-27b0efafdb7b",
      transfer_sent: "1c1bbb09-da4b-4e69-9835-a69342438ed7",
      balls_provided: "c219a3fe-bdee-4e21-ae0c-0504916650fd",
      court_booked: "bcab570e-add5-4082-8928-474508113771",
      transfer_received: '6dc04656-184a-4ae1-99b9-e726d6988ba9',
      pies: '3f211c34-6257-47fa-85c4-38d68530eba9',
      match_fee: 'edbccc86-d6ad-4057-a3c5-8d7a54f9c507',
      championship_fee: 'eb2b00b6-9507-4828-a5d3-dfe130ef62e8',
      strings_provided: '1e18bdcc-90e1-439d-b5d0-5508d1234e9d',
      ladder_c_fee: '6abd785c-3f66-4937-a5a4-6c9b4a1c82c5',
      wine: '9ba92cd1-24e0-441e-b643-37271d4191b9',
      cancelled: '57f61307-f16c-46d0-b54d-2f25b47a1789'
    }
    @other_pattern = /.*/
  end

  def get_event_type_from_event_string(event_string, decimal_amount)
    event_type = "unknown".to_sym

    if (event_string == "c fee")
      event_type = :c_fee
    elsif (event_string == "paid" || event_string == "paypal" || event_string == "cash" || event_string == "b trans")
      event_type = :transfer_sent
    elsif (event_string == "balls")
      event_type = :balls_provided
    elsif (event_string == "booking")
      event_type = :court_booked
    elsif (event_string == "pies" || event_string == 'm pies')
      event_type = :pies
    elsif (event_string == "wine")
      event_type = :wine
    elsif (event_string == "cancelled")
      event_type = :cancelled
    elsif (event_string == 'trans' || event_string == 'trnsfr' || event_string.include?('transfer'))
      event_type = :transfer_received
    elsif (event_string == "m fee" || event_string == 'match')
      event_type = :match_fee
    elsif (event_string == "champ")
      event_type = :championship_fee
    elsif (event_string == "strings")
      event_type = :strings_provided
    elsif (event_string == "ladder")
      event_type = :ladder_c_fee
    else
      raise EventTypeUnknownError.new(), "#{event_string} unknown, amount: #{decimal_amount.to_s}"
    end

    return event_type
  end

  def from_note(note, player_name)
    practice_date, event_string, amount_sign, amount = note.match(@@note_pattern).captures

    event_string = event_string.downcase

    decimal_amount = BigDecimal.new(amount_sign + amount)

    player_id = @team_member_service.get_team_member_id_by_name(player_name)

    event_type = get_event_type_from_event_string(event_string, decimal_amount)

    event = {
      event_id: @uuid_service.new_uuid,
      player_id: player_id,
      event_type_id: @events[event_type],
      event_date: @time_service.now,
      amount: decimal_amount.to_s("F")
    }

    if (event_type == :c_fee ||
        event_type == :balls_provided ||
        event_type == :wine ||
        event_type == :pies ||
        event_type == :cancelled)
      event[:practice_date] = Time.parse(practice_date)
    end

    if (event_type == :transfer_sent)
      event[:transfer_sent_to] = "5a74ba2a-3af9-4cad-8243-71cfda9dfd4a"

      if (event_string == "paid")
        event[:transferred_via] = "system"
      elsif (event_string == "b trans")
        event[:transferred_via] = "bank"
      else
        event[:transferred_via] = event_string
      end

      event[:amount] = (0 - decimal_amount.abs).to_s("F")
    end

    if (event_type == :transfer_received)
      if (event_string =~ /transfer from (.+)/)
        transfer_sender_name = event_string.match(/transfer from (.+)/).captures
        transfer_sender_id = @team_member_service.get_team_member_id_by_name(transfer_sender_name)
        event[:transfer_sent_from] = transfer_sender_id
      else
        event[:transfer_sent_from] = '5a74ba2a-3af9-4cad-8243-71cfda9dfd4a'
      end
      event[:transferred_via] = 'system'
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
    return (event_string.downcase == "carried")
  end
end