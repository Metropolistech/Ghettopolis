class RemoveIsReleasedFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :is_released if column_exists? :projects, :is_released
  end
end
