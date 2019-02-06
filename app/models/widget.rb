class Widget < ApplicationRecord

  # Widget - Table ( usign single table inheritance )
  #
  # type: string 
  # dashboard_id: int
  # options: text ( serialized as HASH ) different key/values based on widget
  # name: string
  include SharedFeatures
  
  serialize :options, Hash
  
  belongs_to :dashboard
  has_one :bound, dependent: :destroy
  has_many :data_values # destroyed manually
  has_many :alerts, dependent: :destroy
  has_many :request_logs, dependent: :destroy
  
  accepts_nested_attributes_for :bound
  accepts_nested_attributes_for :alerts, :reject_if => lambda { |a| (a[:email_address].blank? && a[:phone_number].blank?) || a[:occurring_rate].blank? }, allow_destroy: true

  validates :dashboard_id, :bound, presence: true
  
  # TYPES - array that contains all widgets types and labels that exist in the db
  #       - can be used in views, etc.. 
  TYPES = [
    {type: "Widgets::GitHub::Issue", provider: "GitHub", label: "Issues"},
    {type: "Widgets::GitHub::PullRequest", provider: "GitHub", label: "Pull Requests"},
    {type: "Widgets::NewRelic::ApDex", provider: "NewRelic", label: "Apdex"},
    {type: "Widgets::NewRelic::ResponseTime", provider: "NewRelic", label: "Response Time"},
    {type: "Widgets::NewRelic::MemoryUsage", provider: "NewRelic", label: "Memory Usage"},
    {type: "Widgets::HoneyBadger::Fault", provider: "HoneyBadger", label: "Fault"},
    {type: "Widgets::IFrame", provider: "", label: "IFrame"},
    {type: "Widgets::JenkinsTestSuite", provider: "Coverage", label: "Test Suite"}
  ]
  
  # REFRESH_TYPES - array of types, used in the Sidekiq Refresh Job
  #               - to know what type of widgets to refresh
  REFRESH_TYPES = [
    "Widgets::GitHub::Issue",
    "Widgets::GitHub::PullRequest",
    "Widgets::NewRelic::ApDex",
    "Widgets::NewRelic::ResponseTime",
    "Widgets::HoneyBadger::Fault"
  ]
  
  # Returns { value: 13, time: 03:22PM, in_bounds: true } - hash
  # Fromt the most recent data_value
  # For Widgets::JenkinsTestSuite, we have this method defined in jenkins_test_suite.rb
  def value
    data = data_values.current_value

    return { value: data[0], time: data[1].try(:strftime, "%I:%M%p") || "", in_bounds: data[2] }
  end
  
  # Virtual method that is implemented in child classes
  def get_info
  end
  
  # True - value is within the bounds
  # False - otherwise => send alerts
  def check_bounds(value)
    return value >= self.bound.lower_bound && value <= self.bound.upper_bound
  end
  
  def save_with_hooks
    is_new_record = self.new_record?
    
    get_info if self.changed?
    check_message_alerts
    self.save!
    
    self.dashboard.update_column(:layout, []) if is_new_record
  end
  
  def check_message_alerts
    message_alerts = self.alerts.map { |a| a if ( a.new_record? || a.changed? ) && a.is_a?(Alerts::TextMessage) }.compact
    message_alerts.map(&:verify_phone_number) if message_alerts.present?
    return true
  end

end
