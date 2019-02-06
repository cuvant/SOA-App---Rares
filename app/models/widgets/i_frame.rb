class Widgets::IFrame < Widget
  before_validation :set_bound

  serialized_options_attr_accessor :url
  
  # Validates the presence of custom attributes required for IFrame widgets
  validates :url, presence: true
  validates :url, url: true

  def provider
    return "IFrame"
  end
  
  # Sets the model name to Widget
  # So form_for will route to WidgetsController using 'widget' params
  def self.model_name
    Widget.model_name
  end
  
  private
  def set_bound
    self.build_bound(lower_bound: 0, upper_bound: 1)
    return true
  end

end
