class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :companies_attributes

  #associations
  has_many :companies, :through => :companies_users
  has_many :companies_users

  has_many :tournament_users
  has_many :tournaments, through: :tournament_users

  accepts_nested_attributes_for :companies
end
