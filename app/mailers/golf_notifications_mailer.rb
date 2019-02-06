class GolfNotificationsMailer < ApplicationMailer
  default from: "dashboards@cc.com", reply_to: "dashboards@mail.com"
  layout "mail"

  def notify(email, text, job, name)
    @text = text
    @job = job
    @name = name
    mail to: email, subject: "#{name} Alert! Tomorrow you work #{job}!", cc: GolfGenius::Employee.where(for_cc: true).pluck(:email)
  end

end
