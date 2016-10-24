class CreateConsults < ActiveRecord::Migration[5.0]
  def change
    create_table :consults do |t|
      t.integer :user_id, null: false
      t.integer :parent_id
      t.integer :admin_id
      t.text :content, null: false, limit: 500
      t.integer :status, null: false, default: 0
      t.boolean :unread, null: false, default: false
      t.boolean :admin_reply, null: false, default: false

      t.timestamps
    end
    add_index :consults, :user_id
    add_index :consults, :admin_reply
  end
end
