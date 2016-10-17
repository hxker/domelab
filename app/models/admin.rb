class Admin < ApplicationRecord
  has_secure_password
  include AccountConcern
  has_many :groups, foreign_key: :teacher_id
  mount_uploader :avatar, AvatarUploader
  mount_uploaders :teacher_avatar, CoverUploader


  validates :job_number, presence: true, length: {minimum: 3, maximum: 5}, uniqueness: true
  validates :password, length: {minimum: 6, maximum: 20}, allow_blank: true
  validates :password, presence: true, on: :create
  validates :name, :permissions, presence: true
  validates :email, allow_blank: true, uniqueness: true, format: {with: /\A[^@\s]+@[^@\s]+\z/, message: '格式不正确或已被使用'}
  validates :phone, allow_blank: true, uniqueness: true, length: {is: 11}, format: {with: /\A[1][34578][0-9]{9}\z/, message: '格式不正确或已被使用'}
  validates :avatar, allow_blank: true, file_size: {less_than: 1.megabyte, message: '文件大小不能超过1M'}

  PERMISSIONS = {
      super_admin: '超级管理员',
      admin: '管理员',
      super_editor: '总编',
      editor: '编辑',
      score: '成绩录入员',
      audit: '审核员',
      teacher: '教师',
  }

  GENDER = {male: 1, female: 2}

  def auth_permissions(permissions)
    if permissions.is_a?(Array) and self.permissions.present?
      (self.permissions.split(',') & permissions).count > 0
    else
      FALSE
    end
  end
end

