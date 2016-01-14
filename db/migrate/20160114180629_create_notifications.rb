class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :notification_type
      t.timestamp :seen_at
      t.references :project, index: true, foreign_key: true
      t.references :backstage_post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
