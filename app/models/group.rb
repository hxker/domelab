class Group < ApplicationRecord
  has_many :group_user_ships, :dependent => :destroy
  has_many :users, through: :group_user_ships
  has_many :group_course_ships, :dependent => :destroy
  has_many :courses, through: :group_course_ships
  validates :name, presence: true, uniqueness: true
  validates :teacher_id, presence: true
  validates :class_address, presence: true
  validates :wx_code, presence: true
  mount_uploader :wx_code, CoverUploader
end
