class CreateGroupOpus < ActiveRecord::Migration[5.0]
  def change
    create_table :group_opus do |t|
      t.integer :group_id, null: false
      t.integer :course_id, null: false
      t.integer :user_id, null: false
      t.string :content, null: false
      t.integer :liked_user_ids, default: [], array: true
      t.integer :likes_count, default: 0

      t.timestamps
    end
    add_index :group_opus, :group_id
    add_index :group_opus, :course_id
    add_index :group_opus, :user_id
  end
end
