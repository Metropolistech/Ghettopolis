class MetropolisMailer < ApplicationMailer
  def send_mail_to_winner_followers(user: nil, project: nil)
    mail(to: user.email, subject: 'Metropolis - Un projet que vous avez soutenu est sélectionné.') do |format|
      format.html {
        render locals: {
          project_name: project.title,
          author: project.author.username,
          project_slug: project.slug
        }
      }
    end
  end
end
