#!/usr/bin/ruby -w

=begin
  Created:          26/02/2005 - 00:24:53 (CET)
  Last Modified:    27/02/2005 - 18:16:38 (CET)
  
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

################################################################################################
# volume.rb is designed to be use with mrtg and give you volume exchanged on a given interface #
################################################################################################

## Usage:
#
# volume.rb [-i interface] [--ifconfig path] [--hostname path] [--uptime path] | [--help]


### Default values ###
hostname = "/bin/hostname"
uptime = "/usr/bin/uptime"
ifconfig = "/sbin/ifconfig"
interface = "eth0"

### !!! Nothing should be change below this line !!! ###

require "getoptlong"

# Parsing command-line arguments
opts = GetoptLong.new(
                      [ "--interface", "-i", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--ifconfig", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--hostname", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--uptime", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--help", GetoptLong::NO_ARGUMENT ]
        )

begin
    opts.each do |opt, arg|
        case opt
            when "--interface" then
                interface = arg
            when "--ifconfig" then
                ifconfig = arg
            when "--hostname" then
                hostname = arg
            when "--uptime" then
                uptime = arg
            when "--help" then
                puts File.basename($0) + ":"
                puts "\t--interface, -i  : interface to monitor"
                puts "\t--ifconfig       : path to ifconfig program"
                puts "\t--hostname       : path to hostname program"
                puts "\t--uptime         : path to uptime program"
                puts "\t--help           : this help"
                exit(0)
        end
    end
rescue GetoptLong::InvalidOption
    puts "Try #{File.basename($0)} --help"
    exit(1)
end

# Getting volume exchange informations
`#{ifconfig} #{interface}`.each_line do |l|
    if l =~ /RX bytes:(\d+) .* TX bytes:(\d+)/ then
        $my_in = $1.to_i
        $my_out = $2.to_i
    end
end

# Getting a usefull uptime and hostname
parts = `uptime`.split(/,|\s+/)

ut = parts[3] + " " + parts[4] + " and " + parts[6]
if parts[7] == "min" then
    ut = ut + " minutes"
else
    ut = ut + " hours"
end

hn = `hostname`

# Printing values
if $my_in.kind_of?(Numeric) and $my_out.kind_of?(Numeric) then
    puts $my_in
    puts $my_out
    puts ut
    puts hn
    exit(0)
else # There's an error
    puts 0
    puts 0
    puts ut
    puts hn
    exit(1)
end

# Quitting
exit(0)
