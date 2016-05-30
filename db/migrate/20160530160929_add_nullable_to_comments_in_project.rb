class AddNullableToCommentsInProject < ActiveRecord::Migration
  def change
    change_column :projects, :comments, :jsonb, null: true, default: '{}'
  end
end
