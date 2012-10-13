class AddGameTypeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :game_type, :integer, :limit => 1
    add_column :tournaments, :company_id, :integer
  end
end
