class ChangeColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :guid
    remove_index :users, :guid
  end
end
