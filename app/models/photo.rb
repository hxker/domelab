class Photo < ApplicationRecord
  validates :photo_type, presence: true
  validates :type_id, presence: true
  validates :image, file_size: {less_than: 1.megabyte, message: '大小不能超过1M'}
  mount_uploader :image, CoverUploader
end
