class DestroyDataValuesWorker
  include Sidekiq::Worker

  def perform(widget_id)
    DataValue.where(widget_id: widget_id).destroy_all
  end
end
