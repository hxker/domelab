class GroupCourseShip < ApplicationRecord
  belongs_to :group
  belongs_to :course, required: true
  scope :left_j_group_user, -> { joins('left join group_user_ships g_u on g_u.group_id = group_course_ships.group_id') }
  scope :left_j_lesson, -> { joins('left join lessons l on l.course_id = group_course_ships.course_id') }
  validates :group_id, presence: true, uniqueness: {scope: :course_id, message: '一个班级不能包含同一课程两次'}
  validates :course_id, presence: true
end