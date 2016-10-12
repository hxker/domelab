class ChangeColumnToUserLessonTests < ActiveRecord::Migration[5.0]
  def change
    change_column :user_lesson_tests, :right_percent, 'numeric USING CAST(right_percent AS numeric)', null: false
  end
end
