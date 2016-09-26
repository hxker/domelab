class LessonTest < ApplicationRecord
  belongs_to :lesson
  validates :lesson_id, :name, :option_1, :option_2, :option_3, :option_4, :answer, presence: true
  validates :answer, inclusion: ['1', '2', '3', '4']
  after_validation :check_option

  private
  def check_option
    if [option_1, option_2, option_3, option_4].uniq! != nil
      errors[:answer] << '四个选项中出现重复'
    end
    # self.answer = self["option_#{answer}"]
  end
end
