class RemoveNotificationTypeReferencesAndUpdateNotification < ActiveRecord::Migration
  def change
    remove_reference :notifications, :notification_type
    remove_column :notifications, :notif_duty_id
    remove_column :notifications, :notif_duty_type

    add_column :notifications, :type, :string, presence: true
    add_column :notifications, :payload, :jsonb
  end
end
