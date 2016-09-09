class GroupCourseShip < ApplicationRecord
  belongs_to :group
  belongs_to :course, required: true
  validates :group_id, presence: true, uniqueness: {scope: :course_id, message: '一个班级不能包含同一课程两次'}
  validates :course_id, presence: true
end