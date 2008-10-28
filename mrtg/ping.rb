#!/usr/bin/ruby -w

=begin
  Created:          24/02/2005 - 15:23:00 (CET)
  Last Modified:    28/02/2005 - 20:36:25 (CET)
  
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

###################################################################
# ping.rb is designed to be use with mrtg and give you ping stats #
###################################################################

## Usage:
#
# ping.rb [-h example.com] [-c number] [--hostname path] [--uptime path] | [--help]

### Default values ###
host = "www.free.fr"
count = 10
hostname = "/bin/hostname"
uptime = "/usr/bin/uptime"

### !!! Nothing should be change below this line !!! ###

require "getoptlong"

# Parsing command-line arguments
opts = GetoptLong.new(
                      [ "--host", "-h", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--count", "-c", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--hostname", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--uptime", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--help", GetoptLong::NO_ARGUMENT ]
        )

begin
    opts.each do |opt, arg|
        case opt
            when "--host" then
                host = arg
            when "--count" then
                count = arg.to_i
            when "--hostname" then
                hostname = arg
            when "--uptime" then
                uptime = arg
            when "--help" then
                puts File.basename($0) + ":"
                puts "\t--host, -h  : host to ping"
                puts "\t--count, -c : number of ping to send"
                puts "\t--hostname  : path to hostname program"
                puts "\t--uptime    : path to uptime program"
                puts "\t--help      : this help"
                exit(0)
        end
    end
rescue GetoptLong::InvalidOption
    puts "Try #{File.basename($0)} --help"
    exit(1)
end
      
# Pinging host and retrieving interesting values
ping = `ping -c#{count} #{host} | grep avg`

if ping =~ /avg\S+ = (\S+)\/(\S+)\/(\S+)/ then
    puts $1
    puts $3
else
    puts 0
    puts 0
end

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
