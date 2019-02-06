class UserMailer < ApplicationMailer
  default from: "dashboards@cc.com", reply_to: "dashboards@mail.com"
  layout "mail"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def reset_password(user)
    @user = user
    mail to: user.email, subject: "Reset Password"
  end

end
