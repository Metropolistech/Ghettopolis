class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@metropolis.watch"
  layout 'mailer'
end
