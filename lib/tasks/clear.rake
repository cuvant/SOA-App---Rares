namespace :clear do
  desc "Clear all sidekiq queed jobs."
  task sidekiq: :environment do
    # 1. Clear retry set

    Sidekiq::RetrySet.new.clear

    # 2. Clear scheduled jobs 

    Sidekiq::ScheduledSet.new.clear

    # 3. Clear 'Processed' and 'Failed' jobs statistics

    Sidekiq::Stats.new.reset
  end

end
