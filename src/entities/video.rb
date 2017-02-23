class Video
  attr_accessor :id, :size, :cache_servers

  def initialize(id, size)
    @id = id
    @size = size
  end

  def addToCache(cache)
    @cache_servers << cache
  end

  def to_s
    "Video: ID #{id} #{size}MB"
  end
end
