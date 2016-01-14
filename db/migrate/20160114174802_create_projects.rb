class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :youtube_id
      t.integer :room_max
      t.boolean :is_in_competition

      t.timestamps null: false
    end
  end
end
