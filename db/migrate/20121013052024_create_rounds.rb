class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|

      t.integer :tournament_id, null:false

      t.timestamps
    end
  end
end
