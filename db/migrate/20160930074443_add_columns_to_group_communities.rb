class AddColumnsToGroupCommunities < ActiveRecord::Migration[5.0]
  def change
    add_column :group_communities, :liked_user_ids, :integer, default: [], array: true
    add_column :group_communities, :likes_count, :integer, default: 0
    add_column :group_communities, :mentioned_user_ids, :integer, default: [], array: true
  end
end
