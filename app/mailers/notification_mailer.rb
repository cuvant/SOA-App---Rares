class NotificationMailer < Devise::Mailer
  default from: "dashboards@mail.com", reply_to: "dashboards@mail.com"
  layout "mail"
end
