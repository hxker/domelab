class Photo < ApplicationRecord
  belongs_to :lesson, -> { where photo_type: 1 }
  validates :photo_type, inclusion: {in: ['1']}
  validates :type_id, presence: true
  validates :image, file_size: {less_than: 1.megabyte, message: '大小不能超过1M'}
  after_validation :set_sort, on: :create
  mount_uploader :image, CoverUploader

  private

  def set_sort
    if photo_type == '1'
      last_photo = Photo.where(photo_type: 1, type_id: type_id).last
      if last_photo.present?
        self.sort = last_photo.sort + 1
      end
    end
  end
end