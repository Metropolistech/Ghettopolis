class CreateBackstagePostAccesses < ActiveRecord::Migration
  def change
    create_table :backstage_post_accesses do |t|
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
