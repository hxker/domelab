class School < ApplicationRecord
  has_many :users
  has_many :user_roles
  validates :name, presence: true, uniqueness: true
  validates :district_id, presence: true
end
