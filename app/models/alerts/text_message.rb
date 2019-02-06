class Alerts::TextMessage < Alert
  validates_uniqueness_of :phone_number, scope: :widget_id
  validates :phone_number, presence: true
  validates_format_of :phone_number, :with => /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  attr_accessor :twilio_client
  
  def notify(value, lower_bound, upper_bound, recorded_at, widget_text)
    super
    init_twilio
    send_text_message(self.text)
    self.update_column(:last_sent, Time.zone.now)
  end
  
  def verify_phone_number
    init_test_twilio
    send_text_message("Testing phone number.", "+15005550006")
  end
  
  def send_instructions
    set_token
    init_twilio
    send_text_message("To confirm the phone number, go to 'Pending Verification' and use the following code #{self.confirmation_token}. Thank you for using Dashboards!")
    self.confirmation_sent_at = Time.zone.now
    save!
  end
  
  def verification_text
    "Code sent!"
  end
  
  private
  
  def init_twilio
    self.twilio_client = Twilio::REST::Client.new
  end
  
  def init_test_twilio
    self.twilio_client = Twilio::REST::Client.new(ENV['TWILIO_TEST_SID'], ENV['TWILIO_TEST_TOKEN'])
  end
  
  def send_text_message(body, testing = false)
    begin
      self.twilio_client.api.account.messages.create(
        from: testing || ENV['TWILIO_FROM'],
        to: self.phone_number,
        body: body
      )
    rescue Twilio::REST::RestError => e
      if e.message.include? "#{self.phone_number} is not a valid phone number"
        raise Widgets::Errors::CredentialsError.new("'#{self.phone_number}' is not a valid phone number.")
      end
    end
  end
end
