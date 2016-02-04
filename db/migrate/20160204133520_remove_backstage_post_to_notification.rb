class RemoveBackstagePostToNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :backstage_post if column_exists? :notifications, :backstage_post
  end
end
