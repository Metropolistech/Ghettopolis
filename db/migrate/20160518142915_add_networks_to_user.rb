class AddNetworksToUser < ActiveRecord::Migration
  def change
    add_column :users, :networks, :jsonb, null: false, default: '{"facebook": null, "twitter": null, "linkedin": null, "youtube": null}'
  end
end
