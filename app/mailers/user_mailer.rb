class UserMailer < ActionMailer::Base
  default from: "system@mattandre.me"

  def activate_email(user, set_password_token)
    @user = user
    @set_password_token = set_password_token
    mail(to: @user.email, subject: "Welcome to Sample App")
  end

  def remind_password_email(user, set_password_token)
    @user = user
    @set_password_token = set_password_token
    mail(to: @user.email, subject: "Reset Password")
  end


end
