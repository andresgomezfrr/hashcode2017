require_relative 'entities/endpoint'
require_relative 'entities/video'
require_relative 'entities/request'
require 'pry'

if ARGV.count != 1
  puts 'usage: simulation.rb [file]'
  exit
end
