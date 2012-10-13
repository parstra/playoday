class AddOwnerIdToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :owner_id, :integer
  end
end
