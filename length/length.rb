#!/usr/bin/env ruby
#
# -----------------------------------------------------------------------------
# length.rb - go through a list of OGG / MP3 file to tell the space needed
# on CDR to burn it
# -----------------------------------------------------------------------------
#
# (c) Copyright 2007 Nicolas Cavigneaux. All Rights Reserved.

require 'vorbisfile'
require "mp3info.rb"

if ARGV.empty?
  $stderr.print "Usage: #{File.basename($0)} <file> ...\n"
  exit 1
end

time = 0

ARGV.each do |filename|

  f = File.new(filename, "r")

  if !f
    $stderr.print "Can't open #{filename}\n"
    next
  end

  File.basename(filename) =~ /^.*?\.(...)$/
  
  if $1 == "ogg" then

    vf = Ogg::VorbisFile.new

    time += vf.time_total(-1)   
    vf.close

  elsif $1 == "mp3" then

    vf = Mp3Info.new(filename)

    time += vf.length
    vf.close

  end
  
end

time /= 60.0

if time < 80 then
  puts "Ok for a 80min CDR"
  if time < 70 then
    puts "But there only #{time} Min needed ..."
  end
else
  puts "A 80min CDR is not enough (#{time} needed)"
end
