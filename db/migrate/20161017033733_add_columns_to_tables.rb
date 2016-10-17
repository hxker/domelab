class AddColumnsToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :teacher_avatar, :string, default: [], array: true
    add_column :user_lesson_tests, :group_id, :integer, null: false
    add_column :user_lesson_tests, :answer_result, :jsonb, default: {}
    add_index :user_lesson_tests, [:group_id, :lesson_id]
  end
end