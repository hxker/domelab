class CreateUserLessonTests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_lesson_tests do |t|
      t.integer :user_id, null: false
      t.integer :lesson_id, null: false
      t.string :right_percent, null: false
      t.timestamps
    end
    add_index :user_lesson_tests, :user_id
    add_index :user_lesson_tests, [:user_id, :lesson_id], unique: true, name: 'index_on_user_lesson_tests'
  end
end
