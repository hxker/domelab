class GroupOpu < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :course
  validates :user_id, :group_id, :course_id, presence: true
end
