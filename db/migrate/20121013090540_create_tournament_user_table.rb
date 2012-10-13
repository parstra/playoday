class CreateTournamentUserTable < ActiveRecord::Migration
  def change
    create_table :tournament_users do |t|

      t.integer :user_id, null: false
      t.integer :tournament_id, null: false
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :tournament_users, :user_id
    add_index :tournament_users, :tournament_id
  end
end
