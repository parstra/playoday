class RemoveRoleFromCompaniesUser < ActiveRecord::Migration
  def up
    remove_column :companies_users, :role
  end

  def down
    add_column :companies_users, :role, :integer
  end
end
