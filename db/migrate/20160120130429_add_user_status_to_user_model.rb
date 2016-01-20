class AddUserStatusToUserModel < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :is_creator, :boolean, default: false
  end
end
