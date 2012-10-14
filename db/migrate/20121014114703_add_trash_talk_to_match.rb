class AddTrashTalkToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :home_comment, :string
    add_column :matches, :away_comment, :string
  end
end
