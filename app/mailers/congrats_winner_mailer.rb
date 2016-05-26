class CongratsWinnerMailer < ApplicationMailer
  def send_congrats(to: nil)
   mail(to: to, subject: 'Congrats you won !')
 end
end
