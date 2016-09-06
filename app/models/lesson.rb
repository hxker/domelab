class Lesson < ApplicationRecord
  belongs_to :course
  validates :name, presence: true, uniqueness: {scope: :course_id, message: '同一课程的课时不能重复'}, length: {maximum: 50}
  validates :course_id, presence: true
end
