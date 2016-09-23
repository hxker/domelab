class CreateLessonTests < ActiveRecord::Migration[5.0]
  def change
    create_table :lesson_tests do |t|
      t.integer :lesson_id, null: false
      t.string :name, null: false
      t.integer :test_type, null: false, default: 1
      t.string :option_1, null: false
      t.string :option_2, null: false
      t.string :option_3
      t.string :option_4
      t.string :answer, null: false

      t.timestamps
    end
    add_index :lesson_tests, :lesson_id
    add_index :lesson_tests, [:lesson_id, :name], unique: true
  end
end
