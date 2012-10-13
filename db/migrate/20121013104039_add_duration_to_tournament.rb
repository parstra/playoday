class AddDurationToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :name, :string
    add_column :tournaments, :duration, :integer
    add_column :tournaments, :total_rounds, :integer
    add_column :tournaments, :round_duration, :integer
    add_column :tournaments, :active, :boolean, default: false
  end
end
