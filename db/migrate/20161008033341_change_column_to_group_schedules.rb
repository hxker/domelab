class ChangeColumnToGroupSchedules < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_schedules, :lesson_id
    add_column :group_schedules, :course_id, :integer
    add_index :group_schedules, :course_id
  end
end
