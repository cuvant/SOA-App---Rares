class AlertMailer < ApplicationMailer
  default from: "dashboards@cc.com", reply_to: "dashboards@mail.com"
  layout "mail"
  
  def email_confirmation(alert)
    @alert = alert
    mail to: @alert.email_address, subject: "Confirmation Instructions"
  end
  
  def notify(alert, text)
    @text = text
    mail to: alert.email_address, subject: "Widget Out of Bounds"
  end
end
