class CreateGroupSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :group_schedules do |t|
      t.integer :group_id, null: false
      t.string :title, null: false
      t.datetime :start, null: false
      t.datetime :end
      t.string :className
      t.string :backgroundColor
      t.boolean :allDay, null: false, default: 0
      t.boolean :editable, null: false, default: 0
      t.boolean :startEditable, null: false, default: 0
      t.timestamps
    end
    add_index :group_schedules, :group_id
    add_index :group_schedules, :start
    add_index :group_schedules, :allDay
  end
end
