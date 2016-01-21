class AddReferencesAuthorAndCoverToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :author, references: :users, index: true
    add_reference :projects, :cover, references: :images
  end
end
