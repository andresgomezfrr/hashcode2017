class Endpoint
  attr_accessor :latency, :latency_to_cache, :cache_servers

  def initialize(latency)
    @latency = latency
    @latency_to_cache = {}
    @cache_servers = []
  end

  def setLatencyToCache(cache, latency)
    @latency_to_cache[cache.id] = latency
  end

  def latencyToCache(cache)
    @latency_to_cache[cache.id]
  end
end
