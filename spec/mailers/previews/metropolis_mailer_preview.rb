# Preview all emails at http://localhost:3000/rails/mailers/metropolis_mailer
class MetropolisMailerPreview < ActionMailer::Preview
  def send_mail_to_winner_followers
    MetropolisMailer
      .send_mail_to_winner_followers(user: User.first, project: Project.first)
  end

  def send_mail_for_new_round
    MetropolisMailer
      .send_mail_for_new_round(to: User.first.email)
  end

  def send_congrats_to_winner
    MetropolisMailer
      .send_congrats_to_winner(user: User.first)
  end
end
