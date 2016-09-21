class Course < ApplicationRecord
  has_many :lessons, :dependent => :destroy
  has_many :group_course_ships
  has_many :groups, through: :group_course_ships
  has_many :course_stars, :dependent => :destroy
  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :course_type, presence: true
  validates :status, presence: true
  validates :cover, presence: true
  TYPE = {豆姆: 0, 专家: 1}
  STATUS = {待显示: 0, 显示: 1, 结束: 2, }
  mount_uploader :cover, CoverUploader
  attr_accessor :content
end
