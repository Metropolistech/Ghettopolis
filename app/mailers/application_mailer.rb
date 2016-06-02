class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@metropolis.watch"
  layout 'mailer'

  def send_mail_to_winner_followers(to: nil, project: nil)
    mail(to: to, subject: 'A new project is selected.')
  end
end
