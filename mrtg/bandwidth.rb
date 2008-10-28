#!/usr/bin/ruby -w

=begin
  Created:          24/02/2005 - 20:45:42 (CET)
  Last Modified:    28/02/2005 - 22:24:55 (CET)
  
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

##############################################################################
# bandwidth.rb is designed to be use with mrtg and give your bandwidth usage #
##############################################################################

## Usage:
#
# bandwidth.rb [-i interface] [-s statfile] [--hostname path] [--uptime path] | [--help]

### Default values ###
interface = "eth0"
statfile = "/proc/net/dev"
hostname = "/bin/hostname"
uptime = "/usr/bin/uptime"

### !!! Nothing should be change below this line !!! ###

require "getoptlong"


# Parsing command-line arguments
opts = GetoptLong.new(
                      [ "--interface", "-i", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--statfile", "-s", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--hostname", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--uptime", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--help", "-h", GetoptLong::NO_ARGUMENT ]
        )

begin
    opts.each do |opt, arg|
        case opt
            when "--interface" then
                interface = arg
            when "--statfile" then
                statfile = arg
            when "--hostname" then
                hostname = arg
            when "--uptime" then
                uptime = arg
            when "--help" then
                puts File.basename($0) + ":"
                puts "\t--interface, -i  : interface to monitor"
                puts "\t--statfile, -s   : stats file to use"
                puts "\t--hostname       : path to hostname program"
                puts "\t--uptime         : path to uptime program"
                puts "\t--help, -h       : this help"
                exit(0)
        end
    end
rescue GetoptLong::InvalidOption
    puts "Try #{File.basename($0)} --help"
    exit(1)
end

# Function to read the stats file and return catched values
def read(iface, sf)
    File.open(sf, "r") do |f|
        f.each_line do |l|
            if l =~ /#{iface}:\s*(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)\s+/ then
                values = [true, $1, $2]
                return values
            end
        end
    end
end

# Function that prints 0 values in case of error
def error(hn, ut)
    puts 0
    puts 0
    puts ut
    puts hn + " Unknown Interface: #{interface}"
    exit(1)
end

# Getting a usefull uptime and hostname
parts = `uptime`.split(/,|\s+/)
ut = parts[3] + " " + parts[4] + " and " + parts[6]
if parts[7] == "min" then
    ut = ut + " minutes"
else
    ut = ut + " hours"
end

hn = `hostname`.chomp

# Main program
found = read(interface, statfile)

# Values were not found, exiting with 0 values
error(hn, ut) if found[0] == false

# Printing the result
print(found[1], "\n", found[2], "\n", ut, "\n", hn, "\n")

# Quitting
exit 0
