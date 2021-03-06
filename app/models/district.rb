class District < ApplicationRecord
  has_many :users
  has_many :user_roles
  has_many :schools
  validates :name, presence: true, uniqueness: {scope: :city, message: '同一城市的区县不同重复'}
  validates :city, presence: true
end
