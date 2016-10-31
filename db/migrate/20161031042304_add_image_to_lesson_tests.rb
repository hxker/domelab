class AddImageToLessonTests < ActiveRecord::Migration[5.0]
  def change
    add_column :lesson_tests, :cover, :jsonb
  end
end
