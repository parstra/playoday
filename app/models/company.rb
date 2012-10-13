class Company < ActiveRecord::Base
  attr_accessible :domain

  #associations
  has_many  :users, :through => :companies_users
  has_many :companies_users, :dependent => :destroy

  #validations
  validates_presence_of :domain
  validates_uniqueness_of :domain
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  domain     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

