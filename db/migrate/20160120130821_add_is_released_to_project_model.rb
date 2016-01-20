class AddIsReleasedToProjectModel < ActiveRecord::Migration
  def change
    add_column :projects, :is_released, :boolean, default: false 
  end
end
