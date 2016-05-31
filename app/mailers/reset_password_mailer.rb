class ResetPasswordMailer < ApplicationMailer
  def send_reset_password(user: nil)
    mail(to: user.email, subject: "Réinitialiser votre mot de passe Metropolis") do |format|
      format.html {
        render locals: {
          user_name: user.username,
          reset_token: user.reset_password_token
        }
      }
    end
 end
end
