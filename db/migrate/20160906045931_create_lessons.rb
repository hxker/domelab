class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :name, null: false, limit: 50
      t.integer :course_id, null: false
      t.string :content
      t.boolean :status, null: false, default: 1
      t.timestamps
    end
    add_index :lessons, :course_id
    add_index :lessons, [:name, :course_id], unique: true
  end
end
