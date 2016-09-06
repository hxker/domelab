class Group < ApplicationRecord
  belongs_to :course
  has_many :group_user_ships
  validates :name, presence: true, uniqueness: true
  validates :course_id, presence: true
  validates :teacher_id, presence: true
  validates :class_address, presence: true
  attr_accessor :user_id
end
