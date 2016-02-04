class RemoveProjectToNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :project if column_exists? :notifications, :project
  end
end
