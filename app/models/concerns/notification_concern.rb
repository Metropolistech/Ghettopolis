module NotificationConcern
  extend ActiveSupport::Concern

  def notify_project_followers(followers, type_id, payload)
    followers.each do |user|
      create_notification user, get_notification_type_by_id(type_id), payload.dup
    end
  end

  def get_notification_type_by_id(id)
    NotificationType.find_by_id(id).name
  end

  def create_notification(user, notification_type, payload)
    Notification
      .create(user: user, notification_type: notification_type, payload: payload.as_json)
  end
end
