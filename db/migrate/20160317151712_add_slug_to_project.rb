class AddSlugToProject < ActiveRecord::Migration
  def up
    add_column :projects, :slug, :string, unique: true, index: true unless column_exists? :projects, :slug
  end

  def down
    Project.find_each(&:save)
  end
end
