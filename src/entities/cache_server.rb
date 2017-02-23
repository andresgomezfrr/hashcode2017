class CacheServer
  attr_accessor :max_size, :videos

  def initialize(max_size)
    @max_size = max_size
    @videos = []
  end

  def current_size
    @videos.inject(0) { |sum, v| sum + v.size }
  end

  def free_space
    max_size - current_size
  end

  def has_capacity_for?(video)
    free_space > video.size
  end
end
