class AddColumnsToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :english_name, :string
    add_column :courses, :author, :string
  end
end
