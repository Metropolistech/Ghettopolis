class CreateLadderRounds < ActiveRecord::Migration
  def change
    create_table :ladder_rounds do |t|
      t.references :winner, references: :users, default: nil
      t.string :status, null: false, default: :running
      t.jsonb :ladder_state, default: nil
      t.references :last_updater, references: :users, default: nil

      t.timestamps null: false
    end
  end
end
