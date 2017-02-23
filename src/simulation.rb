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
end

input_file.endpoints.each_with_index do |e, i|
  endpoint = Endpoint.new i, e[:datacenter_latency], e[:caches]

  e[:caches].each do |cache_info|
    cache_id = cache_info[:cache_id].to_i
    cache_servers[cache_id] = CacheServer.new(cache_id, input_file.data[:capacity].to_i) if cache_servers[cache_id].nil?
    cache_servers[cache_id].add_endpoint endpoint
  end

  endpoints << endpoint
end

input_file.requests.each_with_index do |r, i|
  video = videos[r[:video_id].to_i]
  endpoint = endpoints[r[:endpoint_id].to_i]
  request = Request.new video, endpoint, r[:requests].to_i
  requests << request
end

# ==== ALGORITHM =======
videos_res = {}
requests.group_by { |r| r.video.id }.each do |video_id, requests|
  videos_res[video_id] = {
    video_id: video_id,
    video_size: videos[video_id].size,
    requests: requests.inject(0) { |a, b| a + b.request_number.to_i },
    caches_ids: requests.inject([]) { |a, b| a + b.endpoint.cache_servers.keys }
  }
end

requests_res = []
requests.each do |request|
  video_id = request.video.id

  requests_res << {
    video_id: video_id,
    video_size: request.video.size,
    requests: request.request_number,
    caches_ids: request.endpoint.cache_servers.keys,
    best_caches: videos_res[video_id][:caches_ids].group_by { |c| c }.sort_by { |a, b| b.size }.reverse.map { |a| a[0] }
  }
end

# puts requests_res.sort_by { |r| r[:requests] / r[:video_size] }.reverse.select { |a| a[:video_id] == 16 }
video_in_caches = {}
requests_res.sort_by { |r| r[:requests] / r[:video_size] }.reverse.each do |video_requests|
  video_requests[:best_caches].each do |cache_id|
    video_id = video_requests[:video_id]
    next unless video_requests[:caches_ids].include? cache_id
    next unless video_in_caches[video_id].nil? || !video_in_caches[video_id].include?(cache_id)

    cache_server = cache_servers[cache_id]
    video = videos[video_id]
    if cache_server.has_capacity_for?(video)
      cache_server.add_video video
      video_in_caches[video_id] ||= []
      video_in_caches[video_id] << cache_id
    end
  end
end

# Output
Output.bulk_file("#{ARGV[0].split('.').first}.out", cache_servers)
