class Widgets::NewRelic::ApDex < Widgets::NewRelic

  # Returns lates Apdex and UserApdex
  def get_info
    begin
      return get_apdex
    rescue RestClient::Unauthorized, RestClient::BadRequest, RestClient::ResourceNotFound => e
      raise Widgets::Errors::CredentialsError.new(handle_exception(e))
    end
  end

  private
  
  def get_apdex
    # "EndUser/Apdex" cand be sent as well, and the response will contain informations for it
    apdex_data = send_request( ["Apdex"], 
                               ["score"], 
                               false
                              )
    parse_response(apdex_data, "score")
  end

end
