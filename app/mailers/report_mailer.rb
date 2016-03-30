class ReportMailer < ApplicationMailer
  def send_worker_fail_report(message: nil)
   mail(to: "alex.delvaque@gmail.com", subject: "[Fail] #{message}")
 end
end
