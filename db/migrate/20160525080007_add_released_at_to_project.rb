class AddReleasedAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :released_at, :timestamp, default: nil
  end
end
