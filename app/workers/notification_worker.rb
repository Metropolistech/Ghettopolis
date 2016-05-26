class NotificationWorker
  require 'yaml'
  @@types = YAML.load(File.read(Rails.root.join('lib/yml', 'notification_types.yml')))

  def self.notify_project_followers(followers, type_id, payload)
    followers.each do |user|
      create_notification user, @@types[type_id], duplicate_payload(payload)
    end
  end

  def self.create_notification(user, notification_type, payload)
    Notification
      .create(
        user: user,
        notification_type: notification_type,
        payload: {
          project: payload.as_json(
            only: [:id, :slug, :title, :status, :youtube_id, :cover],
            except: [:comments, :author],
            include: {
              author: { only: [:id, :username, :avatar]}
            }
          )
        }
      )
  end

  def self.duplicate_payload(payload)
    dup = payload.dup
    dup[:id] = payload.id
    dup
  end
end
