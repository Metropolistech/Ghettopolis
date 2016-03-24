class CongratsWinnerMailer < ApplicationMailer
  def send_congrats(to: nil)
   mail(to: to.author.email, subject: 'Congrats you won !')
 end
end
