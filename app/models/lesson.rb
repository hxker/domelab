class Lesson < ApplicationRecord
  belongs_to :course
  has_many :lesson_tests, :dependent => :destroy
  validates :name, presence: true, uniqueness: {scope: :course_id, message: '同一课程的课时不能重复'}, length: {maximum: 50}
  validates :course_id, presence: true
  validates :content, allow_blank: true, file_size: {less_than: 10.megabyte, message: '文件大小不能超过10兆'}
  mount_uploader :content, LessonUploader
end
