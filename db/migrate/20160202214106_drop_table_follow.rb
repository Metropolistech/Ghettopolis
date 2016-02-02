class DropTableFollow < ActiveRecord::Migration
  def change
    drop_table :follows
  end
end
