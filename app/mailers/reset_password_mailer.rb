class ResetPasswordMailer < ApplicationMailer
  def send_reset_password(user: nil, host: nil)
    mail(to: user.email, subject: "Réinitialiser votre mot de passe Metropolis") do |format|
      format.html {
        render locals: {
          user_name: user.username,
          url_reset: "#{host}/account/password/reset/#{user.reset_password_token}"
        }
      }
    end
 end
end
