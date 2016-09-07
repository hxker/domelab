class CreateGroupCourseShips < ActiveRecord::Migration[5.0]
  def change
    create_table :group_course_ships do |t|
      t.integer :group_id, null: false
      t.integer :course_id, null: false
      t.boolean :status, null: false, default: true

      t.timestamps
    end
    add_index :group_course_ships, :group_id
    add_index :group_course_ships, :course_id
    add_index :group_course_ships, [:group_id, :course_id], unique: true, name: 'index_on_group_course_ships'
  end
end
