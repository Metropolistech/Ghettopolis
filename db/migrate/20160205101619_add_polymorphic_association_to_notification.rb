class AddPolymorphicAssociationToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :notif_duty_type, :string
    add_column :notifications, :notif_duty_id, :integer
  end
end
