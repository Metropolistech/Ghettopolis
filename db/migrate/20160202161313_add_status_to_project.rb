class AddStatusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string, default: "draft", index: true
  end
end
