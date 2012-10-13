class CompaniesUser < ActiveRecord::Base
  attr_accessible :company_id, :role, :user_id

  #associations
  belongs_to :company
  belongs_to :user
end

# == Schema Information
#
# Table name: companies_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  company_id :integer
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

