require_relative 'entities/endpoint'
require_relative 'entities/video'
require_relative 'entities/cache_server'
require_relative 'entities/request'
require_relative 'formatters/output'
require_relative 'input_file'
require 'pry'

if ARGV.count != 1
  puts 'usage: simulation.rb [file]'
  exit
end

# vars
videos = []
endpoints = []
requests = []
cache_servers = {}

# Parse files and create the instances
input_file = InputFile.new ARGV[0]
input_file.parse!

puts ARGV[0]
puts "==============="

puts "#{input_file.data[:videos]} videos, " \
     "#{input_file.data[:endpoints]} endpoints, " \
     "#{input_file.data[:requests]} requests, " \
     "#{input_file.data[:cache_servers]} caches " \
     "#{input_file.data[:capacity]}MB each"

input_file.videos.each_with_index do |v, i|
  video = Video.new(i, v.to_i)
  videos << video
  # puts video
end

input_file.endpoints.each_with_index do |e, i|
  endpoint = Endpoint.new i, e[:datacenter_latency], e[:caches]

  e[:caches].each do |cache_info|
    cache_id = cache_info[:cache_id]
    next unless cache_servers[cache_id].nil?
    cache_servers[cache_id] = CacheServer.new(cache_id, input_file.data[:capacity].to_i)
  end

  endpoints << endpoint
  # puts endpoint
end

input_file.requests.each do |r|
  request = Request.new videos[r[:video_id].to_i], endpoints[r[:request_id].to_i], r[:requests]
  requests << request
  # puts request
end

# This is for TESTING
videos.each do |video|
  cache_servers.each do |k, cs|
    next unless cs.has_capacity_for?(video)
    cs.add_video(video)
  end
end

# Output
Output.bulk_file("#{ARGV[0].split('.').first}.out", cache_servers)
