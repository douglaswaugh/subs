require 'rubyXL'
require 'securerandom'

def player_name_from_row(row)
  if (row[0] && row[0].value)
    return row[0].value.to_sym
  end
  return nil
end

workbook = RubyXL::Parser.parse("/Users/douglas/code/subs/spike-excel-parse/cleaned-7th-team-monies-owed.xlsx")

worksheet = workbook.worksheets[0]

comments = worksheet.comments

comments_by_player = []
comments.first.comment_list.each do |comment|
  row_reference = RubyXL::Reference.ref2ind(comment.ref.to_s)[0]
  if (!comments_by_player[row_reference])
    comments_by_player[row_reference] = []
  end
  comments_by_player[row_reference] = comments_by_player[row_reference] + comment.text.to_s.split('\n')
end

players = {}
player_comments = {}
worksheet.each_with_index do |row,index|
  player_name = player_name_from_row(row)
  if (player_name)
    player_id = SecureRandom.uuid
    players[player_name.to_s] = player_id
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

player_comments.keys.each do |key|
  player_comments[key].each do |event|
    puts event.inspect
    #if (event.downcase.contains "c fee")
    #  event = {}
    #  event[:event_id] = SecureRandom.uuid
    #  event[:player_id] = key.to_s
    #  event[:event_type] = events[:participated_in_practice]
    #end
  end
end