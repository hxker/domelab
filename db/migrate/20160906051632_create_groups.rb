class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.integer :teacher_id, null: false
      t.string :class_address
      t.text :class_schedule
      t.integer :status, null: false, default: 0
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :wx_code
      t.timestamps
    end
    add_index :groups, :name, unique: true
    add_index :groups, :teacher_id
    add_index :groups, :status
    add_index :groups, :end_date
  end
end
