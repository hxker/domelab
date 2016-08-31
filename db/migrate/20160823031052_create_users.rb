class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :guid, null: false, unique: true
      t.string :nickname, null: false, unique: true
      t.string :mobile
      t.string :email
      t.string :fullname
      t.integer :gender
      t.integer :district_id
      t.integer :school_id
      t.string :grade
      t.integer :bj
      t.integer :sk_station
      t.integer :standby_school
      t.string :student_code # 学籍号
      t.string :identity_card, length: {in: 18}
      t.string :nationality # 民族
      t.string :address
      t.string :roles
      t.date :birthday
      t.string :address

      t.timestamps
    end
    add_index :users, :guid, unique: true
    add_index :users, :nickname, unique: true
    add_index :users, :mobile
    add_index :users, :email
    add_index :users, :school_id
    add_index :users, :district_id
    add_index :users, :gender
  end
end
