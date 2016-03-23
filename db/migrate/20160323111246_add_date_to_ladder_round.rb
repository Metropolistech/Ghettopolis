class AddDateToLadderRound < ActiveRecord::Migration
  def change
    add_column :ladder_rounds, :date, :timestamp, default: nil
  end
end
