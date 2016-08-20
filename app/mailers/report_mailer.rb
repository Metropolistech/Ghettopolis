class ReportMailer < ApplicationMailer
  def send_worker_fail_report(message: nil)
   mail(to: ENV[MY_DEV_MAIL], subject: "[Fail] #{message}")
 end
end
