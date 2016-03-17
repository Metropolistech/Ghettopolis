class AddSlugToProject < ActiveRecord::Migration
  def up
    add_column :projects, :slug, :string, unique: true, index: true
  end

  def down
    Project.find_each(&:save)
  end
end
