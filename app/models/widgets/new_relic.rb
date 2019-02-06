class Widgets::NewRelic < Widget

  serialized_options_attr_accessor :application_id, :api_key, :application_name
  
  # Validates the presence of custom attributes required for NewRelic widgets
  validates :application_name, :application_id, :api_key, :bound, presence: true
  
  # Virtual method that is implemented in child classes
  def get_info
  end
  
  # Returns provider type
  # Used in dashboard edit view
  def provider
    return "New Relic"
  end
  
  # Sets the model name to Widget
  # So form_for will route to WidgetsController using 'widget' params
  def self.model_name
    Widget.model_name
  end
  
  def alert_text
    return "#{self.application_name} #{self.label_type} widget. "
  end
  
  protected
  
  # Sends request to new relic and returns the decoded JSON
  # parameter - metric_names, values, summarize
  
  # 'metric_names' can be only one string or an array (string) ex. ["HttpDispatcher", "Apdex"] || "Apdex"
  # Exmaple of metric_names: "HttpDispatcher" "Apdex" "EndUser/Apdex", and much more
  
  # 'values' - are the values we want from the 'metric_names', for example: ["average_call_time", "call_count"]
  # 'values' - is not required by NewRelic API, if not provided will returl all values corresponding to a 'metric_name'
  
  # 'summarize' - true / false, if true will return the average of last 30 minutes
  # else will return all 'values' for last 30 minutes
  
  # Check https://rpm.newrelic.com/api/explore/applications/metric_names for full list

  def send_request(metric_names, values, summarize)
    
    response = RestClient::Request.execute(
          :url => "https://api.newrelic.com/v2/applications/#{application_id}/metrics/data.json",
          :method => :get,
          :headers => {'X-Api-Key'=> api_key},
          :payload => {:names => metric_names, :values => values, :summarize => summarize},
          :verify_ssl => false
    )

    return ActiveSupport::JSON.decode(response.body)
  end
  
  def send_summary_request
    response = RestClient::Request.execute(
          :url => "https://api.newrelic.com/v2/applications/#{application_id}.json",
          :method => :get,
          :headers => {'X-Api-Key'=> api_key},
          :verify_ssl => false
    )

    return ActiveSupport::JSON.decode(response.body)
  end
  
  def handle_exception(e)
    return JSON.parse(e.response)["error"]["title"]
  end

  def parse_response(data, metric)
    # This will force DataValue to save -1 value, this means an error.
    return -1 unless data["metric_data"].present? && data["metric_data"]["metrics_found"].present?
    
    timeslices = data["metric_data"]["metrics"].first["timeslices"]

    return most_recent_timeslice(timeslices, metric)
  end

  def most_recent_timeslice(timeslices, metric)
    return timeslices[timeslices.count - 1]["values"][metric]
  end

end
