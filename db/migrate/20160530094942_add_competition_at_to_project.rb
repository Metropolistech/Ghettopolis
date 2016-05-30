class AddCompetitionAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :competition_at, :timestamp, default: nil
  end
end
