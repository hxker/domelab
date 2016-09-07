class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false, limit: 60
      t.integer :course_type, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.string :cover
      t.text :course_star
      t.text :course_info
      t.string :keyword
      t.timestamps
    end
    add_index :courses, :name, unique: true
    add_index :courses, :status
    add_index :courses, :course_type
  end
end
