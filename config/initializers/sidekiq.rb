# url = ENV["REDISTOGO_URL"] || "redis://localhost:6379/0"
# uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
# 
# 
Sidekiq.configure_server do |config|
  config.redis = { size: 5, url: 'redis://redis:6379' }
end

Sidekiq.configure_client do |config|  
  config.redis = { size: 5, url: 'redis://redis:6379' }
end  

# $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)

# redis_conn = proc {
#   Redis.new # do anything you want here
# }
# 
# Sidekiq.configure_client do |config|
#   config.redis = ConnectionPool.new(size: 5, &redis_conn)
# end
# 
# Sidekiq.configure_server do |config|
#   config.redis = ConnectionPool.new(size: 25, &redis_conn)
# end
