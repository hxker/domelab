class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :image, null: false
      t.string :photo_type, null: false
      t.integer :type_id, null: false, default: 0
      t.boolean :status, null: false, default: true
      t.integer :sort, null: false, default: 1

      t.timestamps
    end
    add_index :photos, :photo_type
    add_index :photos, :type_id
    add_index :photos, :status
  end
end
