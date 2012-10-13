class CompaniesUser < ActiveRecord::Base
  attr_accessible :company_id, :role, :user_id

  #associations
  belongs_to :company
  belongs_to :user
end
