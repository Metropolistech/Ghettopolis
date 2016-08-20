class AddCommentsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :comments, :jsonb, null: false, default: '{}'
    # use GIN indexation, faster than GiST
    # @see: http://www.postgresql.org/docs/9.1/static/textsearch-indexes.html
    add_index :projects, :comments, using: :gin
  end
end
