class UpdateImageToPolymorphic < ActiveRecord::Migration
  def change
    remove_column :images, :url if column_exists? :images, :url
    remove_column :images, :height if column_exists? :images, :height
    remove_column :images, :width if column_exists? :images, :width

    add_column :images, :image_name, :string
    add_column :images, :img_target_id, :integer
    add_column :images, :img_target_type, :string
  end
end
