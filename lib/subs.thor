#!/usr/bin/env ruby

require 'rubygems'
require 'thor'

class Subs < Thor 
  desc "add-practice", "add a new practice" 
  method_option :players,:type => :array,:desc => "the people that played in the practice"
  def add_practice 
    puts "start #{options.inspect}"
  end
end