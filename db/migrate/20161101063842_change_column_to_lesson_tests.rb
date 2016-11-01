class ChangeColumnToLessonTests < ActiveRecord::Migration[5.0]
  def change
    remove_column :lesson_tests, :answer
    add_column :lesson_tests, :answer, :text, array: true, default: []
  end
end
