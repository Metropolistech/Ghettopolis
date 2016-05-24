class NotificationType < ActiveRecord::Base
  belongs_to :notifications
  validates :name, presence: true
end
