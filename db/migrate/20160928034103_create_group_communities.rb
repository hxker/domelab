class CreateGroupCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :group_communities do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.text :content, null: false
      t.integer :parent_id
      t.boolean :anonymous

      t.timestamps
    end
    add_index :group_communities, :group_id
    add_index :group_communities, :parent_id
    add_index :group_communities, :user_id
  end
end
