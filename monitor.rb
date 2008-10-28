#!/usr/bin/ruby -w

=begin
  Created:          06/06/2005 - 21:26:53 (CEST)
  Last Modified:    10/24/2008 - 01:39:31 (CEST)
  
  Copyright (c) 2005-2008 by Nicolas Cavigneaux <nico@bounga.org>
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

###################################################################################
#                                   monitor.rb                                    #
#                                      v0.1                                       #
#                                                                                 #
# A way to easily monitor files created in a given directory (and subdirectories) #
###################################################################################

### Usage:
# Monitor the current directory:
# $ monitor.rb
#
# Monitor a given directory:
# $ monitor.rb path/
###

# Some config variables
time_to_wait = 5 # Time to wait (seconds) between verifications
mail_to = ["root@localhost", "other@host.org"] # Mail addresses to contact for the report
smtp = "localhost" # SMTP server to use for mail sending
path_to_ignore = ["/home/user/public_html/", "/home/other/test/"] # Path (absolute) to ignore during the scan

#################################################
### NOTHING SHOULD BE CHANGED BELOW THIS LINE ###
#################################################

require "net/smtp"
require "time"

# Getting path to monitor
path = ARGV[0] || Dir.pwd

# Verifying that the path given exists
unless File.directory?(path)
    $stderr.puts "ERROR: The given directory doesn't exists"
    $stderr.puts "usage: #{$0} <directory>"
    exit(1)
end

# Function to get the file list
def retrive(path, ignore)
    files = Dir["#{path}/**/*"]
    # relative paths to absolute paths
    files.collect! { |f| File.expand_path(f) }
    # deleting directories we don't want to monitor
    unless ignore.empty?
        files.each do |f|
            ignore.each do |i|
                files -= f.to_a if f =~ /^#{i}/
            end
        end
    end
    return files
end

# Getting our first listing
files = retrive(path, path_to_ignore)

# Main loop
loop do
    # wait between verifications
    sleep(time_to_wait)
    # getting new listing
    new = retrive(path, path_to_ignore)
    
    unless files == new
        # we only want to know new files
        diff = new - files
        unless diff.empty?
            # creating mail
            msgstr = <<END_OF_MESSAGE
From: FTP Monitor <noreply@#{smtp}>
To: #{mail_to.join(",")}
Subject: New files list
Date: #{Time.now.rfc2822}


On #{Time.now} the following new files were detected:
#{diff.join("\n")}
END_OF_MESSAGE
            # sending mail
            Net::SMTP.start(smtp, 25) { |serv| serv.send_message msgstr, "noreply@#{smtp}", mail_to }
        end
        # updating our available files array
        files = new
    end
end
