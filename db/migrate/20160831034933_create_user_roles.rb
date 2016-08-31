class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.integer :user_id, null: false
      t.integer :role_id, null: false
      t.integer :status # 0 待审核, 1 通过, 2 未通过
      t.integer :role_type, null: false, default: 0
      t.text :desc
      t.string :cover
      t.integer :district_id
      t.integer :school_id
      t.timestamps
    end
    add_index :user_roles, :user_id
    add_index :user_roles, :role_id
    add_index :user_roles, :status
    add_index :user_roles, [:user_id, :role_id, :role_type], unique: true, name: 'index_user_roles'
    add_index :user_roles, :school_id
    add_index :user_roles, :district_id
  end
end
