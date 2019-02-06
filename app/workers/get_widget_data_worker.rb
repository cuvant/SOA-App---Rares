class GetWidgetDataWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(widget_id)
    widget = Widget.includes(:bound).where(id: widget_id).first
    
    begin
      value, total_used, instance_count = widget.get_info
      value = value.to_f

      data_value = DataValue.create!( widget_id: widget.id,
                                      value: value,
                                      recorded_at: Time.zone.now,
                                      in_bounds: widget.check_bounds(value),
                                      lower_bound: widget.bound.lower_bound,
                                      upper_bound: widget.bound.upper_bound,
                                      total_used: total_used,
                                      instance_count: instance_count
                                    )

      # if Dashboard.online?(widget.dashboard_id) # returns true / false
      #   StreamDasbhoardDataWorker.perform_async(widget.dashboard_id, 
      #                                           { widget_id: widget.id, 
      #                                             dashboard_id: widget.dashboard_id, 
      #                                             value: data_value.value, 
      #                                             recorded_at: data_value.recorded_at.strftime("%I:%M%p"), 
      #                                             in_bounds: data_value.in_bounds
      #                                           }
      #                                          )
      # end
      
      if !data_value.in_bounds? && widget.alerts.verified.any?
        NotifyAlertsWorker.perform_async(data_value.id)
      end

    rescue Widgets::Errors::CredentialsError => e
      # Add exception behaviour code
      # TODO We need a logger
      
    end
  end
end
