class CourseStar < ApplicationRecord
  belongs_to :course
  validates :course_id, presence: true
  validates :name, presence: true, uniqueness: {scope: :course_id, message: '同一课程的星级属性不能重复'}
  validates :stars, inclusion: [1, 2, 3, 4, 5]
end
