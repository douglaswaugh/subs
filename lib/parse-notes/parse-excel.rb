require 'rubyXL'
require 'securerandom'
require 'json'
require_relative '../note_line_splitter'
require_relative '../event_builder'
require_relative '../time_service'
require_relative '../uuid_service'
require_relative '../team_member_service'

def player_name_from_row(row)
  if (row[0] && row[0].value)
    return row[0].value.to_sym
  end
  return nil
end

workbook = RubyXL::Parser.parse("./lib//parse-notes/cleaned-7th-team-monies-owed.xlsx")

worksheet = workbook.worksheets[0]

comments = worksheet.comments

comments_by_player = {}
comments.first.comment_list.each do |comment|
  row_reference = RubyXL::Reference.ref2ind(comment.ref.to_s)[0]
  if (!comments_by_player[row_reference])
    comments_by_player[row_reference] = []
  end
  comments_by_player[row_reference] = comments_by_player[row_reference] + NoteLineSplitter.split(comment.text.to_s)
end

player_ids_by_name = {}
player_names_by_id = {}
player_comments = {}
worksheet.each_with_index do |row,index|
  player_name = player_name_from_row(row)
  if (player_name)
    player_id = SecureRandom.uuid
    player_ids_by_name[player_name.to_sym] = player_id
    player_names_by_id[player_id.to_sym] = player_name
    player_comments[player_id.to_sym] = comments_by_player[index]
  end
end

events = {
  participated_in_practice: "03ecf736-732f-4dfe-b67c-92869dc5e93a",
  transfer_received: "1c1bbb09-da4b-4e69-9835-a69342438ed7",
  provided_balls: "c219a3fe-bdee-4e21-ae0c-0504916650fd",
  booked_court: "bcab570e-add5-4082-8928-474508113771",
  paid: "355d9ff9-b41d-4842-870c-5a1e26e5342e"
}

event_builder = EventBuilder.new(UUIDService.new, TimeService.new, TeamMemberService.new(player_ids_by_name))

player_comments.keys.each do |key|
  puts player_names_by_id[key]
  player_comments[key].each do |note|
    if (EventBuilder.valid_note?(note) && !EventBuilder.carried_event?(note))
      puts event_builder.from_note(note, player_names_by_id[key]).to_json
    end
  end
end