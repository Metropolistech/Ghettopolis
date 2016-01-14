class CreateTeamRoles < ActiveRecord::Migration
  def change
    create_table :team_roles do |t|
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
