class NotificationType < ActiveRecord::Base
  validates :name, presence: true
end
