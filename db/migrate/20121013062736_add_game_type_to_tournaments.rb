class AddGameTypeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :game_type, :integer, :limit => 1
    add_column :tournaments, :company_id, :integer
    add_index :tournaments, :company_id
  end
end
