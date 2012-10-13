class RemoveDomainFromCompany < ActiveRecord::Migration
  def up
    remove_column :companies, :domain
  end

  def down
    add_column :companies, :domain, :string
  end
end
