class CacheServer
  attr_accessor :id, :max_size, :videos, :endpoints

  def initialize(id, max_size)
    @id = id
    @max_size = max_size
    @videos = {}
    @endpoints = []
  end

  def add_endpoint(endpoint)
    @endpoints << endpoint
  end

  def current_size
    sum = 0
    @videos.each do |k, v|
      sum += v.size
    end
    sum
  end

  def free_space
    max_size - current_size
  end

  def has_capacity_for?(video)
    free_space > video.size
  end

  def add_video(video)
    @videos[video.id] = video
  end

  def to_s
    "#{id} #{videos.values.map(&:id).join(' ')}"
  end
end
