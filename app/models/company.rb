class Company < ActiveRecord::Base
  attr_accessible :domain

  #associations
  has_many  :users, :through => :companies_users
  has_many :companies_users, :dependent => :destroy

  #validations
  validates_presence_of :domain
  validates_uniqueness_of :domain
end
