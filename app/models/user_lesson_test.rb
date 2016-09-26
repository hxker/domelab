class UserLessonTest < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  validates :user_id, :lesson_id, :right_percent, presence: true
  validates :lesson_id, uniqueness: {scope: :user_id, message: '一个课时用户只能答一次题'}
end
