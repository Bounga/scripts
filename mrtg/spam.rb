#!/usr/bin/ruby -w

=begin
  Created:          01/03/2005 - 20:00:46 (CET)
  Last Modified:    01/03/2005 - 20:07:37 (CET)
  
  Copyright (c) 2005 by Nicolas "Bounga" Cavigneaux <nico@bounga.org>
  See COPYING for License detail.
 
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.
 
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
=end

###########################################################################
# spam.rb is designed to be use with mrtg and give you number of filtered #
# spams using a file to get the current number of spams catched           #
###########################################################################

## Usage:
#
# spam.rb [-f path] | [--help]

### Default values ###
file = "/tmp/spam_count.tmp"

### !!! Nothing should be change below this line !!! ###

require "getoptlong"

# Parsing command-line arguments
opts = GetoptLong.new(
                      [ "--file", "-f", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--help", "-h", GetoptLong::NO_ARGUMENT ]
        )

begin
    opts.each do |opt, arg|
        case opt
            when "--file" then
                file = arg
            when "--help" then
                puts File.basename($0) + ":"
                puts "\t--file, -f  : file to use to get current number of catched spams"
                puts "\t--help      : this help"
                exit(0)
        end
    end
rescue GetoptLong::InvalidOption
    puts "Try #{File.basename($0)} --help"
    exit(1)
end
      
# Getting current number of filtered spams
count = 0
if File.exist?(file) then
    File.open(file, "r") { |f| f.each_line { |l| count = l } }
end

puts count
puts count

# Getting a usefull uptime and hostname
parts = `uptime`.split(/,|\s+/)

ut = parts[3] + " " + parts[4] + " and " + parts[6]
if parts[7] == "min" then
    ut = ut + " minutes"
else
    ut = ut + " hours"
end

puts ut
puts `hostname`

# Quitting
exit 0
