class RenamePostsTable < ActiveRecord::Migration
  def change
    rename_table :posts, :files
  end 
end
