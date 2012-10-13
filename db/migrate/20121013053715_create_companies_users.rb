class CreateCompaniesUsers < ActiveRecord::Migration
  def change
    create_table :companies_users do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :role

      t.timestamps
    end
  end
end
