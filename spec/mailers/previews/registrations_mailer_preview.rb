# Preview all emails at http://localhost:3000/rails/mailers/registrations_mailer
class RegistrationsMailerPreview < ActionMailer::Preview
  def welcome
    RegistrationsMailer.confirmation_instructions(User.first, "abc")
  end
end
