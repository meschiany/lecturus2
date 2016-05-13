class AddPostAddress < ActiveRecord::Migration
	def change
	  	change_table :posts do |t|
		  	t.string :address
		end
  	end
end
