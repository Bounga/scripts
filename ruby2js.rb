#!/usr/bin/env ruby
#
# -----------------------------------------------------------------------------
# ruby2js.rb - go through an RJS file and output the JavaScript
# -----------------------------------------------------------------------------
#
# (c) Copyright 2007 Nicolas Cavigneaux. All Rights Reserved. 

# TODO: add command-line arguments handling
# TODO: redirect output to a file

require 'rubygems'
require 'actionpack'
require 'action_controller'

require 'optparse'

include ActionView::Helpers::JavaScriptHelper
include ActionView::Helpers::PrototypeHelper
include ActionView::Helpers::ScriptaculousHelper

### Parsing Command Line ###
out_file = nil # File to write the JS to
output = nil # Generated JS
 
ARGV.options do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options] FILENAME"
  opts.define_head "Convert a RJS script to JS"
  opts.separator "Options:"
 
  opts.on("-o", "--outfile file", String, "File you want to write the generated JS to") { |arg| out_file = arg }
  opts.on_tail("-h", "--help", "Show this help") { puts opts; exit(0) }
  
  filenames = opts.parse!

  code = File.read(filenames.first)

  # Convert to JS
  eval <<-EoC
  output = update_page do |page|
    #{code}
  end
  EoC

  # Print output
  if out_file.nil?
    STDOUT.puts output
  else
    File.open(out_file, 'w') { |f| f.write(output) }
  end
end
