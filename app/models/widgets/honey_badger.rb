class Widgets::HoneyBadger < Widget
  
  serialized_options_attr_accessor :access_token, :project_id, :application_name
  
  # Validates the presence of custom attributes required for GitHub widgets
  validates :access_token, :project_id, :application_name, presence: true
  
  # Virtual method that is implemented in child classes
  def get_info
  end

  # Returns provider type
  # Used in dashboard edit view
  def provider
    "Honey Badger"
  end
  
  # Sets the model name to Widget
  # So form_for will route to WidgetsController using 'widget' params
  def self.model_name
    Widget.model_name
  end
  
  protected
  
  # Config the access token
  def config_honey_badger
    Honeybadger::Api.configure do |c|
      c.access_token = self.access_token
    end
  end
  
end
