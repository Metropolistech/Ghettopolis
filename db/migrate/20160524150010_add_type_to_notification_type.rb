class AddTypeToNotificationType < ActiveRecord::Migration
  def change
    remove_column :notification_types, :content
    add_column :notification_types, :type, :string
  end
end
