module NotificationConcern
  extend ActiveSupport::Concern

  def notify_project_followers(followers, type, duty)
    followers.each do |user|
      create_notification user, type, duty
    end
  end

  def create_notification(user, notification_type_id, notif_duty)
    Notification
      .create(user: user, notification_type_id: notification_type_id, notif_duty: notif_duty)
  end
end
