class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :guid , null: false ,unique: true
      t.string :nickname

      t.timestamps
    end
  end
end
