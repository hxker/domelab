class News < ApplicationRecord
  belongs_to :admin
  validates :name, presence: true, uniqueness: true, length: {maximum: 60}
  validates :news_type, :content, :desc, :cover, :admin_id, presence: true
  mount_uploader :cover, CoverUploader
  mount_uploader :sss,CoverUploader
  mount_uploaders :images, CoverUploader
  TYPE = {'类型1': 1, 类型2: 2}
  attr_accessor :sss
end
