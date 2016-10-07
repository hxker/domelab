class AddColumnToRelativeGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :group_opus, :status, :integer, null: false, default: 0
    add_index :group_opus, :status
    add_column :group_schedules, :lesson_id, :integer
    add_index :group_schedules, :lesson_id
  end
end
