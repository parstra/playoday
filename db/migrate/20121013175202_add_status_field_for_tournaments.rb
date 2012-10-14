class AddStatusFieldForTournaments < ActiveRecord::Migration
  def up
    add_column :tournaments, :status, :integer, :limit => 1, :default => 0
  end

  def down
    remove_column :tournaments, :status
  end
end
