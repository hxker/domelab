class LessonTest < ApplicationRecord
  belongs_to :lesson
  validates :lesson_id, :name, :option_1, :option_2, :option_3, :option_4, :answer, presence: true
  after_validation :check_option

  private
  def check_option
    if [option_1, option_2, option_3, option_4].uniq! != nil
      errors[:answer] << '四个选项中出现重复'
    end
  end
end
