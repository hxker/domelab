class Course < ApplicationRecord
  has_many :lessons, :dependent => :destroy
  has_many :group_course_ships
  has_many :groups, through: :group_course_ships
  has_many :course_stars, :dependent => :destroy
  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :course_type, :cover, :status, presence: true
  validates :course_type, inclusion: {in: [0, 1]}
  validates :english_name, :author, presence: true, if: 'course_type==1'

  TYPE = {豆姆: 0, 名师: 1}
  STATUS = {待显示: 0, 显示: 1, 结束: 2}
  mount_uploader :cover, CoverUploader
  attr_accessor :content
end
