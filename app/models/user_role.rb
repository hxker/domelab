class UserRole < ApplicationRecord
  belongs_to :role
  belongs_to :user
  belongs_to :district
  belongs_to :school
  validates :user_id, presence: true, uniqueness: {scope: :role_id, message: '一个用户的同一角色不同重复'}
  validates :role_id, presence: true
  mount_uploader :cover, CoverUploader
end
