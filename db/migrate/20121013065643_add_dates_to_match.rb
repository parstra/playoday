class AddDatesToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :matchdate, :datetime
    add_column :matches, :match_hash, :string
    add_column :matches, :home_score, :integer
    add_column :matches, :away_score, :integer
    add_column :matches, :played, :boolean, default: false

    add_index :matches, :match_hash
  end
end
