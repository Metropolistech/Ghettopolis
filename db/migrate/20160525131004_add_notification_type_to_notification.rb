class AddNotificationTypeToNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :type

    add_column :notifications, :notification_type, :string, presence: true
  end
end
