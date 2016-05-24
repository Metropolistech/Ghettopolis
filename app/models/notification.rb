class Notification < ActiveRecord::Base
  belongs_to :notif_duty, polymorphic: true
  belongs_to :user
  belongs_to :notification_type
end
