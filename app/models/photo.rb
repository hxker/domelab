class Photo < ApplicationRecord
  validates :photo_type, presence: true
  validates :type_id, presence: true
  mount_uploader :image, CoverUploader
end
