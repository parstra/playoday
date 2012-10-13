class AddGameTypeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :game_type, :integer, :limit => 1
  end
end
