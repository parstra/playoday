class AddOwnerIdToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :owner_id, :integer
    add_index :tournaments, :owner_id
  end
end
