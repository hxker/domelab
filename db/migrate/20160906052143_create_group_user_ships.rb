class CreateGroupUserShips < ActiveRecord::Migration[5.0]
  def change
    create_table :group_user_ships do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.integer :status, null: false, default: 1

      t.timestamps
    end
    add_index :group_user_ships, :user_id
    add_index :group_user_ships, :group_id
    add_index :group_user_ships, [:user_id, :group_id], unique: true
  end
end
