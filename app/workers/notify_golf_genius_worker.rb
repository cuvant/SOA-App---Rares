class NotifyGolfGeniusWorker
  include Sidekiq::Worker

  def perform
    GolfGenius::Notify.new.run
  end
end
