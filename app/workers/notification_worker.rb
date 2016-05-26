class NotificationWorker
  require 'yaml'
  @@types = YAML.load(File.read(Rails.root.join('lib/yml', 'notification_types.yml')))

  def self.notify_project_followers(followers, type_id, project_id)
    followers.each do |user|
      create_notification user, @@types[type_id], project_id
    end
  end

  def self.create_notification(user, notification_type, project_id)
    Notification
      .create(
        user: user,
        notification_type: notification_type,
        project_id: project_id
      )
  end
end
