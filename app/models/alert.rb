class Alert < ApplicationRecord
  
  # Alert - Table ( usign single table inheritance )
  #
  # type: string 
  # widget_id: int
  
  include SharedFeatures
  
  belongs_to :widget
  has_one :dashboard, through: :widget
  has_one :user, through: :dashboard
  
  validates :time_type, :occurring_rate, presence: true
  
  after_create_commit { SendConfirmationInstructionsWorker.perform_async(self.id) }
  
  scope :unverified, -> { where(verified: false) }
  scope :verified, -> { where(verified: true) }
  
  attr_accessor :text
  
  TYPES = [
    {type: "Alerts::Email", label: "Email"},
    {type: "Alerts::TextMessage", label: "Message"}
  ]

  def notify(value, lower_bound, upper_bound, recorded_at, widget_text)
    self.text = "Values recorded in the past #{occurring_rate} #{time_type.pluralize(occurring_rate)} are outside the bounds #{lower_bound}-#{upper_bound}. For #{widget_text} Currently the value is #{value}, recorded at #{recorded_at}. #W#{self.widget_id}"
  end
  
  def send_instructions
  end
  
  def resend_instructions
    self.confirmation_sent_at = Time.zone.now - 16.minutes if self.confirmation_sent_at.blank?
    past_time = (( Time.zone.now - self.confirmation_sent_at ) / 60).abs
    
    if past_time > 15
      SendConfirmationInstructionsWorker.perform_async(self.id)
      return true
    else
      return (15 - past_time).round(0)
    end
  end
  
  def set_token
    self.confirmation_token = rand(0000..9999).to_s.rjust(4, "0")
  end
  
  def respects_condition?(recorded_at)
    return false if sent_recenly?
    bounds = DataValue.distinct.where(widget_id: self.widget_id).
                                where("recorded_at >= ?", recorded_at - determine_time).
                                pluck(:in_bounds).compact

    return bounds[0] == false && bounds.size == 1
  end
  
  def mark_verified
    return true if self.verified == true
    self.update_columns(verified: true, confirmed_at: Time.zone.now)
    
    query = { type: self.type }
    
    if self.is_a?(Alerts::Email)
      query[:email_address] = self.email_address
    elsif self.is_a?(Alerts::TextMessage)
      query[:phone_number] = self.phone_number
    end
    
    Alert.where(query).update_all(verified: true, confirmed_at: Time.zone.now)
  end
  
  private
  def sent_recenly?
    return false if self.last_sent.blank?
    return !(Time.zone.now > self.last_sent + 5.minutes)
  end
  
  def determine_time
    case self.time_type
    when "minute"
      occurring_rate.minutes
    when "hour"
      occurring_rate.hours
    end
  end

end
