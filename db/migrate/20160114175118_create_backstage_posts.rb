class CreateBackstagePosts < ActiveRecord::Migration
  def change
    create_table :backstage_posts do |t|
      t.references :project, index: true, foreign_key: true
      t.text :content
      t.references :image, index: true, foreign_key: true
      t.string :youtube_id

      t.timestamps null: false
    end
  end
end
