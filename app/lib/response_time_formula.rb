module ResponseTimeFormula
  # 
  # ***** NewRelic Formula For Response Time *****
  # Response time = 
  # HttpDispatcher:average_call_time + 
  # ( (WebFrontend/Queue:call_count * WebFrontend/Queue:average_response_time) / HttpDispatcher:call_count )
  #
  
  # Parameters 
  # 'response_time' - data from the NewRelic API
  # widget_id - id of the widget who's calling this function
  def self.calculate_collection(response_time, widget_id)
    return unless response_time["metric_data"].present? && response_time["metric_data"]["metrics_found"].present?
    
    http_dispatcher_data, queue_time_data = self.format_data(["HttpDispatcher", "WebFrontend/QueueTime"], response_time["metric_data"]["metrics"])
  
    start_calculate(http_dispatcher_data, queue_time_data, widget_id)
  end
  
  # Calculates the RESPONSE TIME
  # For one time period ( 1 minute )
  def self.calculate(dispatcher, queue)
    response_time = queue["values"]["call_count"] * queue["values"]["average_response_time"]
    response_time = response_time / dispatcher["values"]["call_count"] if dispatcher["values"]["call_count"] != 0
    return response_time + dispatcher["values"]["average_call_time"]
  end
  
  # Returns the request parameters correctly based on the 'metrics' parameters
  # Parameters: 
  # metrics - array of metrics ex: ["HttpDispatcher", "WebFrontend/QueueTime"]
  # values - response data from the NewRelic API
  def self.format_data(metrics, values)
    if values.first["name"] == metrics.first
      return values.first["timeslices"], values.last["timeslices"]
    else
      return values.last["timeslices"], values.first["timeslices"]
    end
  end
  
  private
  
  # Calculates for the past 30 minutes all the RESPONSE TIMES
  # Puts the latest RESPONSE TIME
  def self.start_calculate(dispatcher, queue, widget_id)
    # data_values = []
    
    # (0.. dispatcher.count - 1).each do |index|
    #   data_values << DataValue.new( value: calculate(dispatcher[index], queue[index]),
    #                                 from: dispatcher[index]["from"],
    #                                 to: dispatcher[index]["to"],
    #                                 widget_id: widget_id )
    # end
    
    # TODO we need to save the DataValue objects
    # And move the puts to the model
    # binding.pry here to check DataValues from last 30 min
    # Really good to compare it with NewRelic Web Transaction Time Chart
  
    # puts "New Relic (response time): #{data_values.last.value}ms".colorize(:light_blue)
    # return "New Relic (response time): #{data_values.last.value}ms"
    # return "#{data_values.last.value.round(0)}"
    index = dispatcher.count - 1
    return calculate(dispatcher[index], queue[index]).round(2)
  end
  
end
