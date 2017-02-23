class InputFile
  attr_reader :data, :videos, :endpoints, :requests

  def initialize(filename)
    @filename = filename
    @data = {}
    @endpoints = []
    @requests = []
  end

  def parse!
    file = File.read @filename
    lines = file.split("\n")
    headers = lines.shift.split(' ')

    %w(videos endpoints requests cache_servers capacity).each_with_index do |el, index|
      @data[el.to_sym] = headers[index].to_i
    end

    # Get videos sizes
    @videos = lines.shift.split ' '

    # Get endpoints
    @data[:endpoints].to_i.times do |endpoint_id|
      endpoint_data = lines.shift.split ' '
      datacenter_latency = endpoint_data[0]
      caches_connected = endpoint_data[1]

      @endpoints << {
        datacenter_latencity: datacenter_latency,
        caches: []
      }

      caches_connected.to_i.times do
        endpoint_cache_info = lines.shift.split ' '

        @endpoints[endpoint_id][:caches] << {
          cache_id: endpoint_cache_info[0],
          cache_latency: endpoint_cache_info[1]
        }
      end
    end

    # Get requests
    @data[:requests].to_i.times do
      request_splitted = lines.shift.split ' '
      @requests << { video_id: request_splitted[0], endpoint_id: request_splitted[1], requests: request_splitted[2] }
    end
  end
end