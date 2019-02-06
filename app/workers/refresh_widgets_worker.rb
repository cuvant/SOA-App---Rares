class RefreshWidgetsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(scheduled_time)
    
    Widget.where(type: Widget::REFRESH_TYPES).pluck_in_batches(:id) do |widget_ids|
      widget_ids.each do |widget|
        GetWidgetDataWorker.perform_async(widget)
      end
    end
  end
end
