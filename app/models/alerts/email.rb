class Alerts::Email < Alert
  validates_uniqueness_of :email_address, scope: :widget_id
  validates :email_address, presence: true
  validates_format_of :email_address, :with => Devise::email_regexp
  
  def notify(value, lower_bound, upper_bound, recorded_at, widget_text)
    super
    AlertMailer.notify(self, self.text).deliver
    self.update_column(:last_sent, Time.zone.now)
  end
  
  def send_instructions
    set_token
    AlertMailer.email_confirmation(self).deliver
    self.confirmation_sent_at = Time.zone.now
    save!
  end
  
  def verification_text
    "Email sent!"
  end

end
