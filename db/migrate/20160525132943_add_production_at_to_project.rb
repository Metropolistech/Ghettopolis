class AddProductionAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :production_at, :timestamp, default: nil
  end
end
