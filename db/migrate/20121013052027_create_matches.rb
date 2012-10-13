class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|

      t.integer :round_id, null: false

      t.timestamps
    end
  end
end
