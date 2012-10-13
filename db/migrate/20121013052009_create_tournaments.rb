class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|

      t.string :description, null: false
      t.string :tournament_hash

      t.timestamps
    end
  end
end
