class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :domain

      t.timestamps
    end
  end
end
