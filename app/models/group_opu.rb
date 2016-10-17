class GroupOpu < ApplicationRecord
  include Likeable
  belongs_to :user
  belongs_to :group
  belongs_to :course
  validates :user_id, :group_id, :course_id, presence: true
  validates :content, presence: true, file_size: {less_than: 1.5.megabyte, message: '文件大小不能超过1.5M'}
  mount_uploader :content, CoverUploader
end
