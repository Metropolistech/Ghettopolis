class RenameTypeToNameInNotificationType < ActiveRecord::Migration
  def change
    rename_column :notification_types, :type, :name
  end
end
