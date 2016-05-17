class AddReleasedYoutubeIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :released_youtube_id, :string, default: nil
  end
end
