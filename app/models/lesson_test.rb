class LessonTest < ApplicationRecord
  belongs_to :lesson
  validates :lesson_id, :name, :option_1, :option_2, :option_3, :option_4, :answer, presence: true
  validates :answer, inclusion: ['1', '2', '3', '4']
  after_validation :check_option
  validate :cover_size_validation, if: 'cover?'
  mount_uploaders :cover, CoverUploader

  private
  def check_option
    if [option_1, option_2, option_3, option_4].uniq! != nil
      errors[:answer] << '四个选项中出现重复'
    end
    # self.answer = self["option_#{answer}"]
  end

  def cover_size_validation
    if cover.first.size > 1.megabyte
      errors.add(:cover, '大小不能超过1MB')
    end
  end
end
