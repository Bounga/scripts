#!/usr/bin/ruby -w

=begin
  Created:          25/02/2005 - 23:31:33 (CET)
  Last Modified:    09/03/2005 - 19:33:18 (CET)
  
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
# westats.rb is designed to be use with mrtg and can give you apache hits #
# or apache sent bytes                                                    #
###########################################################################

## Usage:
#
# webstats.rb [--server example.com] [--port number] [--browser] hits | bytes | [--help]

### Default values ###
browser = "elinks -dump"
server = "localhost"
port = 80

### !!! Nothing should be change below this line !!! ###

require "getoptlong"

# Parsing command-line arguments
opts = GetoptLong.new(
                      [ "--server", "-s", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--port", "-p", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--browser", "-b", GetoptLong::REQUIRED_ARGUMENT ],
                      [ "--help", "-h", GetoptLong::NO_ARGUMENT ]
        )
begin
    opts.each do |opt, arg|
        case opt
            when "--server" then
                server = arg
            when "--port" then
                port = arg.to_i
            when "--browser" then
                browser = arg
            when "--help" then
                puts File.basename($0) + "[--server example.com] [--port number] [--browser] hits | bytes | [--help]"
                puts "\t--server, -s  : server to monitor"
                puts "\t--port, -p    : server port to use"
                puts "\t--browser, -b : path to browser program to use to dump info"
                puts "\t--help, -h    : this help"
                exit(0)
        end
    end
rescue GetoptLong::InvalidOption
    puts "Try #{File.basename($0)} --help"
    exit(1)
end

# Getting Apache status
`#{browser} http://#{server}:#{port}/server-status`.each_line do |l|
    if l =~ /Apache Server Status for (.*)/ then $as = $1 end
    if l =~ /Server uptime: (.*)$/ then $ut = $1 end
    if l =~ /Total accesses: (\d+)/ then $accesses = $1 end
    if l =~ /Total Traffic: (\d+)/ then $bytes = $1.to_i * 1024 * 1024 end
end

case ARGV[0]
    when "hits" then
        puts $accesses
        puts $accesses
    when "bytes" then
        puts $bytes
        puts $bytes
    else
        puts 0
        puts 0
end

puts $ut
puts $as

exit 0



