class ProcessJenkinsTestSuiteWorker
  include Sidekiq::Worker

  def perform(value, branch, application_name)
    widgets = Widgets::JenkinsTestSuite.where(options: { application_name: application_name, branch: branch })
    
    decoded_value = DecodeJenkinsRequest.decode(value)
    # example of decoded_value = { lines_covered: 60124, total_lines: 82615, coverage: 72.78 }

    widgets.each do |widget|
      data_value = DataValue.create!( widget_id: widget.id,
                                      value: decoded_value[:coverage],
                                      recorded_at: Time.zone.now,
                                      in_bounds: widget.check_bounds(decoded_value[:coverage]),
                                      lower_bound: widget.bound.lower_bound,
                                      upper_bound: widget.bound.upper_bound,
                                      lines_covered: decoded_value[:lines_covered],
                                      total_lines: decoded_value[:total_lines]
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
      
      if !data_value.in_bounds && widget.alerts.verified.any?
        NotifyAlertsWorker.perform_async(data_value.id)
      end
    end

  end
end
