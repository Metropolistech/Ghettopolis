class RemovePayloadToNotificationAndAddProjectId < ActiveRecord::Migration
  def change
    remove_column :notifications, :payload

    add_column :notifications, :project_id, :integer
  end
end
