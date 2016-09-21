class CreateCourseStars < ActiveRecord::Migration[5.0]
  def change
    create_table :course_stars do |t|
      t.integer :course_id, null: false
      t.string :name, null: false
      t.integer :stars, null: false

      t.timestamps
    end
    add_index :course_stars, :course_id
    add_index :course_stars, [:course_id, :name], unique: true
  end
end
