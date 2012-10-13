class AddActiveToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :active, :boolean
  end
end
