class NotifyAlertsWorker
  include Sidekiq::Worker

  def perform(data_value_id)
    data_value = DataValue.includes(:widget).where(id: data_value_id).first
    alerts = Alert.where(widget_id: data_value.widget_id, verified: true)
    
    alerts.each do |alert|
      if alert.respects_condition?(data_value.recorded_at)
        alert.notify(data_value.value, data_value.lower_bound, data_value.upper_bound, data_value.recorded_at.strftime("%I:%M%p %d/%m/%y"), alert.widget.alert_text)
      end
    end
  end
  
end
