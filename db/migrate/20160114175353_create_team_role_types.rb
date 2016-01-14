class CreateTeamRoleTypes < ActiveRecord::Migration
  def change
    create_table :team_role_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
