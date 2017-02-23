class Endpoint
  attr_accessor :id, :datacenter_latency, :cache_servers

  def initialize(id, datacenter_latency, cache_servers)
    @id = id
    @datacenter_latency = datacenter_latency
    @cache_servers = {}

    cache_servers.each do |cs|
      @cache_servers[cs[:cache_id]] = cs[:cache_latency]
    end
  end

  def set_latency_to_cache(cache, latency)
    @cache_servers[cache.id] = latency
  end

  def latency_to_cache(cache)
    @cache_servers[cache.id]
  end

  def to_s
    "Endpoint: ID #{id} Datacenter latency #{datacenter_latency}ms. Cache servers: #{cache_servers}"
  end
end
