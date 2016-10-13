class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :name, null: false
      t.integer :news_type, null: false
      t.text :desc
      t.string :cover
      t.text :images, default: [], array: true
      t.boolean :status, default: false, null: false
      t.boolean :is_hot, default: false, null: false
      t.text :content
      t.integer :admin_id, null: false

      t.timestamps
    end
    add_index :news, :news_type
    add_index :news, :status
    add_index :news, :is_hot
  end
end
