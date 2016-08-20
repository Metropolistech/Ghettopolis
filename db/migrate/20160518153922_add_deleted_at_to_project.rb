class AddDeletedAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :deleted_at, :timestamp, default: nil
  end
end
