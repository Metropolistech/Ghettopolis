class NotificationWorker
  require 'yaml'
  @@types = YAML.load(File.read(Rails.root.join('lib/yml', 'notification_types.yml')))

  def self.notify_project_followers(followers, type_id, payload)
    followers.each do |user|
      create_notification user, @@types[type_id], payload.dup
    end
  end

  def self.create_notification(user, notification_type, payload)
    Notification
      .create(
        user: user,
        notification_type: notification_type,
        payload: payload.as_json(
          only: [:slug, :title, :status, :youtube_id, :cover],
          except: [:comments, :author],
          include: {
            author: { only: [:id, :username, :avatar]}
          }
        )
      )
  end
end
