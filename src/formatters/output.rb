class Output
  def self.bulk_file(path, cache_servers)
    # puts "== Output =="

    File.open(path, 'w') do |file|
      used_caches = cache_servers.select { |k, cs| cs.videos.size > 0 }.size
      file.write("#{used_caches}\n")
      # puts "#{used_caches}\n"
      file.write(cache_servers.values.join("\n"))
      # puts cache_servers.values.join("\n")
    end
  end
end
