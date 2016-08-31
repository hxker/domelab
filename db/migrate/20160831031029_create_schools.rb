class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :school_uuid, null: false
      t.string :name, null: false
      t.integer :district_id, null: false
      t.integer :teacher_role
      t.integer :school_type
      t.boolean :status, null: false, default: 1
      t.boolean :audit
      t.boolean :user_add, null: false, default: 0
      t.integer :user_id
      t.timestamps
    end
    add_index :schools, :school_uuid, unique: true
    add_index :schools, :name, unique: true
    add_index :schools, :district_id
    add_index :schools, :user_add
    add_index :schools, [:user_id, :user_add, :status], name: 'index_user_add_schools'
    add_index :schools, :status
  end
end
