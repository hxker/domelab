class Course < ApplicationRecord
  has_many :lessons
  has_many :groups
  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :course_type, presence: true
  validates :status, presence: true
  TYPE = {豆姆: 0, 专家: 1}
  STATUS = {待显示: 0, 显示: 1, 结束: 2, }
end
