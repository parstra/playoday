class AddWinnerIdToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :winner_id, :integer, :limit => 3, :null => true

    add_index :tournaments, :winner_id
  end
end
