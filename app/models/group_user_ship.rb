class GroupUserShip < ApplicationRecord
  belongs_to :group
  belongs_to :user
  validates :user_id, presence: true, uniqueness: {scope: :group_id, message: '不能重复参加一个班级'}
  validates :group_id, presence: true
end
