class CongratsWinnerMailer < ApplicationMailer
  def send_congrats(to: nil)
   mail(to: to, subject: 'Metropolis - Félicitations, vous avez gagné !')
 end
end
