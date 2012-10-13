class AddForeignKeysToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :home_player_id, :integer
    add_column :matches, :away_player_id, :integer
    add_column :matches, :winner_id, :integer

    add_index :matches, :home_player_id
    add_index :matches, :away_player_id
  end
end
