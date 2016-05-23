class RemoveCoverIdIfExistOnProject < ActiveRecord::Migration
  def change
    remove_column :projects, :cover_id if column_exists? :projects, :cover_id
  end
end
