# uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
# $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)

# Remove all 'online dashboard' keys
# keys = $redis.keys("dashboard_*")
# $redis.del(*keys) unless keys.empty?
