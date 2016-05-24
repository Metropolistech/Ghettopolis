class NotificationType < ActiveRecord::Base
  has_many :notifications, foreign_key: "notification_type_id", class_name: "Notification"

  validates :name, presence: true
end
