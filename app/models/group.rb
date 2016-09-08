class Group < ApplicationRecord
  has_many :group_user_ships, :dependent => :destroy
  has_many :users, through: :group_user_ships
  has_many :group_course_ships, :dependent => :destroy
  has_many :courses, through: :group_course_ships
  belongs_to :teacher, class_name: User, foreign_key: :teacher_id

  validates :name, presence: true, uniqueness: true
  validates :class_address, :teacher_id, :start_date, :end_date, presence: true
  validates :wx_code, presence: true, file_size: {less_than: 1.megabyte, message: '文件大小不能超过1M'}
  after_validation :check_date

  mount_uploader :wx_code, CoverUploader
  private

  def check_date
    if start_date > end_date
      errors[:start_date] << '不能晚于结束时间'
    end
  end

end
