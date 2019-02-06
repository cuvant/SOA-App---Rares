class Widgets::JenkinsTestSuite < Widget
  serialized_options_attr_accessor :application_name, :branch

  validates :application_name, :branch, presence: true

  # Virtual method that is implemented in child classes
  def get_info
  end
  
  def value
    data = data_values.jenkins_current_value
    return { value: "#{data[0]}%", time: data[1].try(:strftime, "%I:%M%p") || "", in_bounds: data[2], lines_covered: data[3] || "", total_lines: data[4] || "" }
  end

  # Returns provider type
  # Used in dashboard edit view
  def provider
    return "Jenkins Test Suit"
  end
  
  def alert_text
    return ""
  end

  # Sets the model name to Widget
  # So form_for will route to WidgetsController using 'widget' params
  def self.model_name
    Widget.model_name
  end
  
  def alert_text
    return "#{self.application_name} #{self.label_type} widget. "
  end
  
end
