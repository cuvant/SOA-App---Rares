class SendConfirmationInstructionsWorker
  include Sidekiq::Worker

  def perform(alert_id)
    alert = Alert.where(id: alert_id).first
    
    if alert.is_a?(Alerts::TextMessage)
      alert_verified = Alerts::TextMessage.where(phone_number: alert.phone_number, verified: true).any?
    elsif alert.is_a?(Alerts::Email)
      alert_verified = Alerts::Email.where(email_address: alert.email_address, verified: true).any?
      
      if alert_verified == false
        alert_verified = alert.email_address == alert.user.email
      end
    end

    if alert_verified
      alert.update_attribute(:verified, true)
    else
      alert.send_instructions
    end
  end
end
