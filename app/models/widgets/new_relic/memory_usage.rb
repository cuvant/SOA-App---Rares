class Widgets::NewRelic::MemoryUsage < Widgets::NewRelic

  def get_info
    begin
      return get_memory_usage
    rescue RestClient::Unauthorized, RestClient::BadRequest, RestClient::ResourceNotFound => e
      raise Widgets::Errors::CredentialsError.new(handle_exception(e))
    end
  end

  def value
    data = data_values.new_relic_current_value

    return { value: data[0], time: data[1].try(:strftime, "%I:%M%p") || "", in_bounds: data[2], total_used: data[3] || "", instance_count: data[4] || "" }
  end
  
  private
  def get_memory_usage
    total_memory = get_total_memory_usage
    # TODO find a better way of getting instances count
    instance_count = get_number_of_instances
    
    memory_usage_per_instance = ( ( (total_memory / instance_count.to_f) / 1024.to_f ) * 1000 ).round(2)
    
    return memory_usage_per_instance, (total_memory / 1024), instance_count
  end
  
  def get_total_memory_usage
    memory_usage_data = send_request( ["Memory/Physical"], 
                                      ["total_used_mb"], 
                                      false
                                    )
    parse_response(memory_usage_data, "total_used_mb")
  end
  
  def get_number_of_instances
    summary_data = send_summary_request
    return summary_data["application"]["application_summary"]["instance_count"]
  end
end
