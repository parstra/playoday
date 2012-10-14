class UserMailer < ActionMailer::Base
  default from: "noreply@palyoday.com"

  def welcome_message(user)
    @user = user
    @site = "PlayODay"
    mail(:to => user.email, :subject => "Welcome to #{@site}")
  end

end
