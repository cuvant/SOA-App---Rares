class Widgets::NewRelic::ResponseTime < Widgets::NewRelic

  # Returns the most recent timestamp and creates DataValues with the lastest 30 minutes Response Times
  def get_info
    begin 
      return get_response_time
    rescue RestClient::Unauthorized, RestClient::BadRequest, RestClient::ResourceNotFound => e
      raise Widgets::Errors::CredentialsError.new(handle_exception(e))
    end
  end

  private
  
  # Gets the HttpDispatcher time for the last 30 minutes
  # From all that data, ResponseTimeFormula module will calculate for each minute the corresponding response_time
  def get_response_time
    response_time_data = send_request( ["HttpDispatcher", "WebFrontend/QueueTime"], 
                                       ["average_call_time", "call_count", "average_response_time"], 
                                       false
                                     )
    
    # 'calculate_collection' will create DataValues for all 30 minutes
    # Puts the most recent response_time
    ResponseTimeFormula.calculate_collection(response_time_data, self.id)
  end

end
