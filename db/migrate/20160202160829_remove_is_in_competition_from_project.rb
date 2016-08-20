class RemoveIsInCompetitionFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :is_in_competition if column_exists? :projects, :is_in_competition
  end
end
