#!/usr/bin/env ruby
#
# -----------------------------------------------------------------------------
# snapshots.rb - class to get snapshots from a given url
# -----------------------------------------------------------------------------
#
# (c) Copyright 2007 Nicolas Cavigneaux. All Rights Reserved.

# TODO : write a real API documentation

require 'net/http'
require 'rubygems'
require 'xmlsimple'

class Nailer

  @@api_baseurl = 'http://webthumb.bluga.net/api.php'
  @api_key = nil
  
  attr_accessor :collection_time, :job_id, :ok

  def initialize(url, key, width = 1024, height = 768)
    @api_key = key
    api_request = %Q{<webthumb><apikey>#{@api_key}</apikey><request><url>#{url}</url><width>#{width}</width><height>#{height}</height></request></webthumb>}

    result = do_request(api_request)

    if result.class == Net::HTTPOK
      result_data = XmlSimple.xml_in(result.body)
      @job_id = result_data['jobs'].first['job'].first['content']
      @collection_time = Time.now.to_i + result_data['jobs'].first['job'].first['estimate'].to_i
      @ok = true
    else
      @ok = false
    end
  end

  def retrieve(size = :small)
    api_request = %Q{<webthumb><apikey>#{@api_key}</apikey><fetch><job>#{@job_id}</job><size>#{size.to_s}</size></fetch></webthumb>}
    result = do_request(api_request)
    result.body
  end

  def retrieve_to_file(filename, size = :small)
    File.new(filename, 'w+').write(retrieve(size.to_s))
  end

  def ready?
    return unless Time.now.to_i >= @collection_time

    api_request = %Q{<webthumb><apikey>#{@api_key}</apikey><status><job>#{@job_id}</job></status></webthumb>}
    result = do_request(api_request)

    if result.class == Net::HTTPOK
      @ok = true
      result_data = XmlSimple.xml_in(result.body)
      begin
        @result_url = result_data['jobStatus'].first['status'].first['pickup']
        @completion_time = result_data['jobStatus'].first['status'].first['completionTime']
      rescue
        @collection_time += 60 
	      return false
      end
    else
      @ok = false
    end

    true
  end

  def ok?
    @ok == true
  end

  def wait_until_ready
    sleep 1 until ready?
  end

  private

  def do_request(body)
    api_url = URI.parse(@@api_baseurl)
    request = Net::HTTP::Post.new(api_url.path)
    request.body = body
    Net::HTTP.new(api_url.host, api_url.port).start {|h| h.request(request) }
  end
end

# Example usage:
#  
# puts "Enter URL"
# url = gets.chomp
# t = Nailer.new(url, api_key)
# 
# if t.ok?
#   t.wait_until_ready
#   t.retrieve_to_file('out1.jpg', :small)
#   t.retrieve_to_file('out2.jpg', :medium)
#   t.retrieve_to_file('out3.jpg', :medium2)
#   t.retrieve_to_file('out4.jpg', :large)
#   puts "Thumbnails saved"
# else
#   puts "Error"
# end