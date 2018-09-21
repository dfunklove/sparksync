class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user, token)
    @user = user
    @token = token
    puts "user " + @user.type
    puts "first name " + @user.first_name
    puts "last name " + @user.last_name
    puts "id " + @user.id.to_s
#    puts "digest " + user.reset_digest
    puts "token " + @token
    mail to: user.email, subject: "Welcome", id: @user.id
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user, token)
    @user = user
    @token = token
    puts "password reset user " + @user.type + " " + @user.first_name + " " + @user.last_name
    puts "id " + @user.id.to_s
    # puts "digest " + @user.reset_digest
    puts "token " + @token
    mail to: user.email, subject: "Password reset"
  end
end
