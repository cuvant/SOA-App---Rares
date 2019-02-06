class StreamDasbhoardDataWorker
  include Sidekiq::Worker

  def perform(dashboard_id, content)
    ActionCable.server.broadcast "dashboard:#{dashboard_id}", content
  end
end
