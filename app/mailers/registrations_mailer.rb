class RegistrationsMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    @username = record.username
    headers = {
        :subject => "Metropolis - Confirmer votre inscription"
    }
    super
  end
end
