class AddStartDateToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :started_at, :datetime
  end
end
