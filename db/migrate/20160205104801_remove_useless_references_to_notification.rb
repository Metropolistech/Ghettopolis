class RemoveUselessReferencesToNotification < ActiveRecord::Migration
  def change
    remove_reference :notifications, :project
    remove_reference :notifications, :backstage_post
  end
end
