$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "player"
require "player_repository"
require "event_store"
require "event_builder"
require "note_line_splitter"
require "event_type_unknown_error"
require 'team_member_service'
require 'player_ids'
require 'yaml_loader'