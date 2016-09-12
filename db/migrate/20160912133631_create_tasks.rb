class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :h1
      t.string :h2
      t.string :h3
      t.string :links

      t.timestamps null: false
    end
  end
end
