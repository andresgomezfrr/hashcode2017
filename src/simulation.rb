require_relative 'entities/endpoint'
require_relative 'entities/video'
require_relative 'entities/cache_server'
require_relative 'entities/request'
require_relative 'formatters/output'
require 'pry'

if ARGV.count != 1
  puts 'usage: simulation.rb [file]'
  exit
end

@videos = []
@endpoints = []
@requests = []
@cache_servers = []

# Parse files and create the instances
