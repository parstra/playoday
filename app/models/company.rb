class Company < ActiveRecord::Base
  attr_accessible :name

  #associations
  has_many :users

  #validations
  validates_presence_of :name
  validates_uniqueness_of :name
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

