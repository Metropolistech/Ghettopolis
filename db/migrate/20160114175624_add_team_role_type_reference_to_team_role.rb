class AddTeamRoleTypeReferenceToTeamRole < ActiveRecord::Migration
  def change
    add_reference :team_role_types, :team_roles, index: true
  end
end
