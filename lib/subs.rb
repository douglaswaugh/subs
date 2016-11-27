#!/usr/bin/env ruby

require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: opt_parser COMMAND [OPTIONS]'
  opt.separator ''
  opt.separator 'Commands'
  opt.separator '    add-practice: add a new practice'
  opt.separator '    edit-practice: edit a practice'
end

opt_parser.parse!

case ARGV[0]
when 'add-practice'
  puts 'Adding practice'
when 'edit-practice'
  puts 'Editing practice'
else
  puts opt_parser
end

module Subs
  # Your code goes here...
end
