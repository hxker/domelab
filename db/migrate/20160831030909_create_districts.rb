class CreateDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :districts do |t|
      t.string :city, limit: 50
      t.string :name, null: false, limit: 50

      t.timestamps
    end
    add_index :districts, [:name, :city], unique: true
    add_index :districts, :name
    add_index :districts, :city
  end
end
