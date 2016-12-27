#!/usr/bin/env ruby

require 'rubygems'
require 'thor'

class Subs < Thor
  desc "add-practice", "add a new practice" 
  method_option :players,:type => :array,:desc => "People who played"
  method_option :cost,:type => :numeric,:desc => "Cost of court booking"
  method_option :balls,:type => :array,:desc => "People who brought the balls"
  def add_practice
    if options[:players]
      puts "Players"
      options[:players].each { |player| puts "  #{player}" }  
    end
    if options[:cost]
      puts "Cost"
      puts "  #{options[:cost]}" if options[:cost]
    end
    if options[:balls]
      puts "Balls"
      options[:balls].each { |player| puts "  #{player}" }
    end
  end

  desc "balance", "Gets the balance for a player"
  method_option :player,:type => :string,:desc => "Player whose balance you want to get"
  def balance
    if options[:player]
      puts "Player"
      puts "  #{options[:player]}"
    end
  end
end

Subs.start(ARGV)