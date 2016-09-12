class AddWebsiteToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :website, :string
  end
end
