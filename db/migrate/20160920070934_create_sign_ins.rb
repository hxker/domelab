class CreateSignIns < ActiveRecord::Migration[5.0]
  def change
    create_table :sign_ins do |t|
      t.integer :user_id, null: false
      t.integer :continuous_days, null: false, default: 1
      t.integer :sign_count, null: false, default: 1

      t.timestamps
    end
    add_index :sign_ins, :user_id, unique: true
    add_index :sign_ins, :continuous_days
    add_index :sign_ins, :sign_count
  end
end
