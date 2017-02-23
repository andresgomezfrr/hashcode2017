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

# Parse files and create the instances
input_file = InputFile.new ARGV[0]
input_file.parse!

puts "#{input_file.data[:videos]} videos, " \
     "#{input_file.data[:endpoints]} endpoints, " \
     "#{input_file.data[:requests]} requests, " \
     "#{input_file.data[:cache_servers]} caches " \
     "#{input_file.data[:capacity]}MB each"

videos_str = input_file.videos.map { |v| "#{v}MB" }
puts "Videos: #{videos_str}"

input_file.endpoints.each do |e|
  puts "Endpoint: #{e}"
end

input_file.requests.each do |r|
  puts "Request: #{r}"
end
