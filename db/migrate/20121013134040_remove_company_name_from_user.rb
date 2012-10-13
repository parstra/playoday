class RemoveCompanyNameFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :company_name
  end

  def down
    add_column :users, :company_name, :string
  end
end
