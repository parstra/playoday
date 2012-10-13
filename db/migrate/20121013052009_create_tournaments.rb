class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|

      t.string :description
      t.string :tournament_hash

      t.timestamps
    end

    add_index :tournaments, :tournament_hash
  end
end
